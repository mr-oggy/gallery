import 'package:gallery/models/photo_model.dart';
import 'package:image_downloader/image_downloader.dart';

abstract class DownloadRepository {
  Future downloadImage(PhotoModel photoListBean);
}

class CustomDownloadRepository implements DownloadRepository {
  @override
  downloadImage(PhotoModel photoListBean) async {
    await ImageDownloader.downloadImage(
      photoListBean.urls.raw,
      destination: AndroidDestinationType.custom(
        directory: "unsplash",
      )..subDirectory("${photoListBean.id}.jpg"),
    );
  }
}
