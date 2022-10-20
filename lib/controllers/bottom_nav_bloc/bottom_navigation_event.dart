part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationEvent {}

class OnChangeBar extends BottomNavigationEvent {
  int index;

  OnChangeBar({required this.index});
}
