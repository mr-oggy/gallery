import 'package:equatable/equatable.dart';
import 'package:gallery/models/photo_model.dart';

abstract class PhotoListState extends Equatable {
  const PhotoListState();
}

class InitialPhotoListState extends PhotoListState {
  @override
  List<Object> get props => [];
}

class PhotoListError extends PhotoListState {
  @override
  List<Object> get props => [];
}

class PhotoListLoaded extends PhotoListState {
  final List<PhotoModel> photos;
  final int page;

  PhotoListLoaded(this.photos, this.page);

  PhotoListLoaded copyWith(List<PhotoModel> photos) {
    return PhotoListLoaded(photos, page);
  }

  @override
  List<Object> get props => [photos];
}

class SearchListLoaded extends PhotoListState {
  final List<PhotoModel> photos;
  final int page;

  SearchListLoaded(this.photos, this.page);

  SearchListLoaded copyWith(List<PhotoModel> photos) {
    return SearchListLoaded(photos, page);
  }

  @override
  List<Object> get props => [photos];
}
