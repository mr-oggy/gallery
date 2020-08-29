import 'package:equatable/equatable.dart';

abstract class PhotoListEvent extends Equatable {
  const PhotoListEvent();

  @override
  List<Object> get props => [];
}

class FetchEvent extends PhotoListEvent {}

class SearchEvent extends PhotoListEvent {
  final String searchQuery;

  SearchEvent(this.searchQuery);
  @override
  List<Object> get props => [searchQuery];
}
