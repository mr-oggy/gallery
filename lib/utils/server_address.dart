class ServerAddress {
  static final String _baseUrl = 'https://api.unsplash.com/';
  static final String _clientID =
      'e2658d4b6b17ae24b50a7ab36d13ca67da9761322a5e4cb0e9cc531e69cecb90';

  static final Map<String, String> header = {
    'Authorization': 'Client-ID $_clientID',
  };

  static final String getPhotos = _baseUrl + 'photos';
  static final String searchPhotos = _baseUrl + 'search/photos';
}
