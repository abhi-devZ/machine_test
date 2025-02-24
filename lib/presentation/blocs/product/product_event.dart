part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class FetchProductEvent extends ProductEvent {
  FetchProductEvent();
}