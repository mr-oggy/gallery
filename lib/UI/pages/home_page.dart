import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery/UI/widgets/search_text_field.dart';
import 'package:gallery/blocs/photo_list/bloc.dart';
import 'package:gallery/models/photo_model.dart';
import 'package:gallery/repository/download_repository.dart';
import 'package:gallery/repository/photo_repository.dart';
import 'package:gallery/ui/pages/photo_detail.dart';
import 'package:gallery/utils/strings.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static final routeName = "homePage";
  @override
  Widget build(context) {
    return BlocProvider(
      child: PhotoListView(),
      create: (_context) => PhotoListBloc(
        Provider.of<MainPhotoRepository>(context, listen: false),
        // MainPhotoRepository(),
      ),
    );
  }
}

class PhotoListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhotoListViewState();
}

class _PhotoListViewState extends State<PhotoListView>
    with AutomaticKeepAliveClientMixin {
  PhotoListBloc _bloc;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  final borderRadius = BorderRadius.circular(8.0);
  final borderSide = BorderSide(color: Colors.grey.shade50);
  bool isLoading = false;
  String searchText = '';
  Timer _debounce;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    _bloc = BlocProvider.of<PhotoListBloc>(context);
    _bloc.add(FetchEvent());
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce.cancel();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (!isLoading && (maxScroll - currentScroll <= _scrollThreshold)) {
      isLoading = true;
      log('is loading data ${searchText == null || searchText == ''}');
      _bloc.add(
        searchText == null || searchText == ''
            ? FetchEvent()
            : SearchEvent(searchText),
      );
    }
  }

  @override
  Widget build(context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Color(0xFFFEFEFFF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 12),
              SearchTextField(
                onChanged: (value) {
                  if (_debounce?.isActive ?? false) _debounce.cancel();
                  _debounce = Timer(
                    const Duration(milliseconds: 500),
                    () {
                      searchText = value;
                      _bloc.add(
                        searchText == null || searchText.isEmpty
                            ? FetchEvent()
                            : SearchEvent(value),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<PhotoListBloc, PhotoListState>(
                  builder: (buildContext, state) {
                    if (state is PhotoListError)
                      return Center(
                        child: Text("error"),
                      );

                    if (state is InitialPhotoListState)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    if (state is PhotoListError) {
                      return Text('Error');
                    }
                    List<PhotoModel> photos;
                    if (state is PhotoListLoaded) {
                      isLoading = false;
                      photos = state.photos;
                    }
                    if (state is SearchListLoaded) {
                      isLoading = false;
                      photos = state.photos;
                    }
                    if (photos.isEmpty) {
                      return Center(
                        child: Text(AppStrings.noImages),
                      );
                    }
                    return StaggeredGridView.countBuilder(
                      controller: _scrollController,
                      staggeredTileBuilder: (int index) =>
                          StaggeredTile.count(2, index.isEven ? 3 : 1.5),
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 20.0,
                      crossAxisCount: 4,
                      itemCount: photos.length,
                      itemBuilder: (context, int index) => GestureDetector(
                        onTap: () => _onPhotoTap(photos[index]),
                        child: Hero(
                          tag: photos[index].urls.regular,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  photos[index].urls.regular,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onPhotoTap(PhotoModel photoListBean) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoDetailPage(),
        settings: RouteSettings(
          arguments: PhotoDetailPageArguments(
            photoListBean,
            Provider.of<CustomDownloadRepository>(context, listen: false),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
