part of 'visible_container_bloc.dart';

abstract class VisibleContainerEvent {}

class ShowContainer extends VisibleContainerEvent{
  bool isVis;

  ShowContainer({required this.isVis});
}
