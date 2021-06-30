import 'package:ebuzz/constants/constant.dart';

class MapSnapshot {
  static String generateLocationPreviewImage(
      {double latitude, double longitude}) {
    String style = 'feature:poi|visibility:off';
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=15.5&style=$style&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$Map_Key';
  }
}
