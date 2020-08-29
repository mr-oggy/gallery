class PhotoListResponse {
  final List<PhotoModel> results;

  PhotoListResponse(this.results);

  PhotoListResponse.fromJsonArray(List json)
      : results = json.map((i) => new PhotoModel.fromJson(i)).toList();
}

class PhotoModel {
  String id;
  String altDescription;
  int width;
  int height;
  Urls urls;
  User user;

  PhotoModel({
    this.id,
    this.altDescription,
    this.width,
    this.height,
    this.urls,
    this.user,
  });

  PhotoModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.altDescription = json['alt_description'];
    this.width = json['width'];
    this.height = json['height'];
    this.urls = json['urls'] != null ? Urls.fromJson(json['urls']) : null;
    this.user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
}

class Urls {
  String raw;
  String full;
  String regular;
  String small;
  String thumb;

  Urls({this.raw, this.full, this.regular, this.small, this.thumb});

  Urls.fromJson(Map<String, dynamic> json) {
    this.raw = json['raw'];
    this.full = json['full'];
    this.regular = json['regular'];
    this.small = json['small'];
    this.thumb = json['thumb'];
  }
}

class User {
  String id;
  String username;
  String name;
  String firstName;
  String lastName;
  String bio;
  ProfileImage profileImage;

  User(
      {this.id,
      this.username,
      this.name,
      this.firstName,
      this.lastName,
      this.bio,
      this.profileImage});

  User.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.username = json['username'];
    this.name = json['name'];
    this.firstName = json['first_name'];
    this.lastName = json['last_name'];
    this.bio = json['bio'];
    this.profileImage = json['profile_image'] != null
        ? ProfileImage.fromJson(json['profile_image'])
        : null;
  }
}

class ProfileImage {
  String small;
  String medium;
  String large;
  ProfileImage({this.small, this.medium, this.large});

  ProfileImage.fromJson(Map<String, dynamic> json) {
    this.small = json['small'];
    this.medium = json['medium'];
    this.large = json['large'];
  }
}
