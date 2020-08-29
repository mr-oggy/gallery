import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gallery/repository/photo_repository.dart';
import 'package:rxdart/rxdart.dart';
import './bloc.dart';

class PhotoListBloc extends Bloc<PhotoListEvent, PhotoListState> {
  final PhotoRepository photoRepository;

  PhotoListBloc(this.photoRepository) : super(InitialPhotoListState());

  @override
  Stream<Transition<PhotoListEvent, PhotoListState>> transformEvents(
      Stream<PhotoListEvent> events, transitionFn) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap((transitionFn));
  }

  @override
  Stream<PhotoListState> mapEventToState(
    PhotoListEvent event,
  ) async* {
    final currentState = state;
    print(state);
    print(event);
    if (event is FetchEvent) {
      try {
        print('in list event');
        if (currentState is InitialPhotoListState ||
            currentState is SearchListLoaded) {
          final photos = await photoRepository.getPhotos(0);
          yield PhotoListLoaded(photos, 0);
        } else if (currentState is PhotoListLoaded) {
          int currentPage = currentState.page;
          final photos = await photoRepository.getPhotos(currentPage++);
          print("current_page = $currentPage");
          yield photos.isEmpty
              ? currentState.copyWith(photos)
              : PhotoListLoaded(currentState.photos + photos, currentPage);
        }
      } catch (error, stacktrace) {
        yield PhotoListError();
        print(error);
        print(stacktrace);
      }
    }
    if (event is SearchEvent) {
      print('in list search event');
      try {
        if (currentState is PhotoListLoaded ||
            currentState is InitialPhotoListState) {
          yield InitialPhotoListState();
          final photos = await photoRepository.searchPhoto(
            event.searchQuery,
            0,
          );
          yield SearchListLoaded(photos, 0);
        } else if (currentState is SearchListLoaded) {
          print('search list laoded');
          int currentPage = currentState.page;
          final photos = await photoRepository.searchPhoto(
            event.searchQuery,
            currentPage++,
          );

          yield photos.isEmpty
              ? currentState.copyWith(photos)
              : SearchListLoaded(currentState.photos + photos, currentPage);
        }
      } catch (error, stacktrace) {
        yield PhotoListError();
        print(error);
        print(stacktrace);
      }
    }
  }
}
