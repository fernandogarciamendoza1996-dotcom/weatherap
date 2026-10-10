class CityPhotos {
  static const Map<String, String> verifiedPhotos = {
    // Las URLs se agregarán cuando verifiquemos
    // las fotografías y sus licencias.
  };

  static String cityKey(String city, String country) {
    return '${city.trim().toLowerCase()}|'
        '${country.trim().toLowerCase()}';
  }

  static String? getPhoto(String city, String country) {
    return verifiedPhotos[cityKey(city, country)];
  }
}