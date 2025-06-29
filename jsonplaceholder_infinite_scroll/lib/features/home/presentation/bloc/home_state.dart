part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class GetAlbumsState extends HomeState {}

final class GetPhotosState extends HomeState {}

final class ErrorState extends HomeState {}

final class ShowListViewState extends HomeState {}
