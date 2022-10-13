part of 'visible_container_bloc.dart';

abstract class VisibleContainerState {}

class VisibleContainerInitial extends VisibleContainerState {}

class VisibleContainerShow extends VisibleContainerState {
  bool isVis;

  VisibleContainerShow({required this.isVis});
}
