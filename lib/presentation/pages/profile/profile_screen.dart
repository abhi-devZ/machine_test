import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test/data/models/auth_response_model.dart';
import 'package:machine_test/presentation/blocs/profile/profile_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileCubit profileCubit = ProfileCubit();

  @override
  void initState() {
    profileCubit.loadProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        bloc: profileCubit,
        builder: (context, state) {
          switch (state.status) {
            case ProfileStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case ProfileStatus.error:
              return _buildErrorView(context, state.errorMessage);
            case ProfileStatus.loaded:
              return _buildProfileView(context, state.authResponse);
            case ProfileStatus.initial:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String? errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            errorMessage ?? 'An error occurred',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<ProfileCubit>().loadProfile(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView(BuildContext context, AuthResponse? authResponse) {
    if (authResponse == null) {
      return const Center(
        child: Text('No profile information available'),
      );
    }

    return Center(
      child: Card(
        margin: const EdgeInsets.all(16.0),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(context, authResponse),
              const Divider(height: 32),
              _buildProfileDetail(
                icon: Icons.person_outline,
                label: 'Username',
                value: authResponse.username,
              ),
              const SizedBox(height: 16),
              _buildProfileDetail(
                icon: Icons.badge_outlined,
                label: 'Name',
                value: '${authResponse.firstName} ${authResponse.lastName}',
              ),
              const SizedBox(height: 16),
              _buildProfileDetail(
                icon: Icons.email_outlined,
                label: 'Email',
                value: authResponse.email,
              ),
              const SizedBox(height: 16),
              _buildProfileDetail(
                icon: Icons.people_outline,
                label: 'Gender',
                value: authResponse.gender,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AuthResponse authResponse) {
    return Row(
      children: [
        _buildProfileImage(authResponse.image),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${authResponse.firstName} ${authResponse.lastName}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                authResponse.email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage(String? imageUrl) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildDefaultProfileImage(context),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                    ),
                  );
                },
              )
            : _buildDefaultProfileImage(context),
      ),
    );
  }

  Widget _buildDefaultProfileImage(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.2),
      child: Center(
        child: Icon(
          Icons.person,
          size: 32,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildProfileDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
