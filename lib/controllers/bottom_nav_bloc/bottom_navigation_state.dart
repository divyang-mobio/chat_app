part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationState {}

class BottomNavigationInitial extends BottomNavigationState {}

class BottomNavigationLoaded extends BottomNavigationState {
  int index;

  BottomNavigationLoaded({required this.index});
}
