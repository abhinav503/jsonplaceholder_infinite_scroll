part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class GetAlbumsEvent extends HomeEvent {}

class GetPhotosEvent extends HomeEvent {}

class ShowListViewEvent extends HomeEvent {}

class ChangeStateEvent extends HomeEvent {}
