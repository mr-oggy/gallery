import 'package:flutter/material.dart';
import 'package:gallery/UI/pages/home_page.dart';
import 'package:gallery/repository/download_repository.dart';
import 'package:gallery/repository/photo_repository.dart';
import 'package:gallery/ui/pages/photo_detail.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: HomePage.routeName,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            Provider<MainPhotoRepository>(
              create: (context) => MainPhotoRepository(),
              lazy: true,
            ),
            Provider<CustomDownloadRepository>(
              create: (context) => CustomDownloadRepository(),
              lazy: true,
            ),
          ],
          child: child,
        );
      },
      routes: {
        HomePage.routeName: (context) => HomePage(),
        PhotoDetailPage.routeName: (context) => PhotoDetailPage(),
      },
    );
  }
}
