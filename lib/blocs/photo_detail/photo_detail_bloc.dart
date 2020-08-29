import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gallery/models/Photo_model.dart';
import 'package:gallery/repository/download_repository.dart';

import './bloc.dart';

class PhotoDetailBloc extends Bloc<PhotoDetailEvent, PhotoDetailState> {
  final PhotoModel _photoList;
  final DownloadRepository downloadRepository;

  PhotoDetailBloc(this._photoList, this.downloadRepository)
      : super(InitialPhotoDetailState());

  @override
  Stream<PhotoDetailState> mapEventToState(
    PhotoDetailEvent event,
  ) async* {
    final currentState = state;
    if (event is DownloadImageEvent && !(currentState is DownloadingState)) {
      yield* _mapDownloadToState();
    }
  }

  Stream<PhotoDetailState> _mapDownloadToState() async* {
    try {
      yield DownloadingState();
      await downloadRepository.downloadImage(_photoList);
      yield DownloadedState();
    } catch (error, stacktrace) {
      print(error);
      print(stacktrace);
      yield ErrorDownloadingState();
    }
  }
}
