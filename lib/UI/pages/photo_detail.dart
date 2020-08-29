import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery/blocs/photo_detail/photo_detail_bloc.dart';
import 'package:gallery/blocs/photo_detail/photo_detail_event.dart';
import 'package:gallery/blocs/photo_detail/photo_detail_state.dart';
import 'package:gallery/models/Photo_model.dart';
import 'package:gallery/repository/download_repository.dart';
import 'package:permission/permission.dart';

class PhotoDetailPageArguments {
  final PhotoModel photoList;
  final CustomDownloadRepository customDownloadRepository;
  //final UserBean userBean;

  PhotoDetailPageArguments(this.photoList, this.customDownloadRepository);
}

class PhotoDetailPage extends StatelessWidget {
  static final routeName = "photoDetailPage";

  @override
  Widget build(context) {
    PhotoDetailPageArguments args = ModalRoute.of(context).settings.arguments;
    return BlocProvider(
      create: (context) =>
          PhotoDetailBloc(args.photoList, args.customDownloadRepository),
      child: PhotoDetailWidget(
        photoList: args.photoList,
      ),
    );
  }
}

class PhotoDetailWidget extends StatefulWidget {
  final PhotoModel photoList;

  const PhotoDetailWidget({Key key, this.photoList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PhotoDetailWidgetState();
  }
}

class PhotoDetailWidgetState extends State<PhotoDetailWidget> {
  PhotoDetailBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<PhotoDetailBloc>(context);
    super.initState();
  }

  @override
  Widget build(context) {
    return BlocBuilder<PhotoDetailBloc, PhotoDetailState>(
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Hero(
                tag: widget.photoList.urls.regular,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.60,
                  child: CachedNetworkImage(
                    imageUrl: widget.photoList.urls.regular,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Container(
                      height: 35,
                      width: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF64707B),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        size: 18,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Card(
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                    ),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: CachedNetworkImageProvider(
                                  widget.photoList.user.profileImage.medium,
                                ),
                              ),
                            ),
                            Text(
                              '${widget.photoList.user.username}',
                              style: TextStyle(fontSize: 18),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FloatingActionButton(
                                elevation: 0.0,
                                backgroundColor: Colors.white,
                                onPressed: () async {
                                  _onSavePressed();
                                },
                                child: (state is DownloadingState)
                                    ? _buildLoading()
                                    : Icon(
                                        Icons.cloud_download,
                                        color: Colors.black,
                                      ),
                              ),
                            )
                          ],
                        ),
                        //SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('${widget.photoList.altDescription}'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _checkPermission() async {
    var permissions = await Permission.getPermissionsStatus([
      PermissionName.Storage,
    ]);
    return permissions[0].permissionStatus == PermissionStatus.allow;
  }

  _onSavePressed() async {
    if (await _checkPermission()) {
      _bloc.add(DownloadImageEvent());
    } else {
      await _requestPermission();
      _onSavePressed();
    }
  }

  _requestPermission() async {
    // ignore: unused_local_variable
    var permissionNames =
        await Permission.requestPermissions([PermissionName.Storage]);
  }

  _buildLoading() {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
    );
  }
}
