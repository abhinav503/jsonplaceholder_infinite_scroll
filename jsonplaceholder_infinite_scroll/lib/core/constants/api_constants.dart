class ApiConstants {
  static const String jsonPlaceholderApiUrl =
      "https://jsonplaceholder.typicode.com";
  static const String apiPrefix = String.fromEnvironment(
    "BASE_URL",
    defaultValue: jsonPlaceholderApiUrl,
  );
  static const String albumsApi = "/albums";
  static const String photosApi = "/photos";
}
