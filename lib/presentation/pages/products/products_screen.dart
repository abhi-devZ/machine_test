import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test/data/repositories/product_remote_repository.dart';
import 'package:machine_test/domain/repositories/product_repository.dart';
import 'package:machine_test/presentation/blocs/product/product_bloc.dart';

import '../../../di/injectionContainer.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  ProductBloc bloc = ProductBloc(repository: il<ProductRepositoryRemote>());

  @override
  void initState() {
    bloc.add(FetchProductEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: bloc,
      builder: (context, state) {
        return Container();
      },
    );
  }
}
