import 'package:yonaki/services/networking.dart';

class AddressService {
  static const geoAPIURL =
      'http://geoapi.heartrails.com/api/json?method=searchByGeoLocation';

  dynamic getAddress(double lat, double lng) async {
    NetworkHelper networkHelper = NetworkHelper('$geoAPIURL&x=$lng&y=$lat');

    var res = await networkHelper.getData();

    if (res['response']['error'] == null)
      return res['response']['location'][0];

    print('位置情報が不正です');
    return null;
  }
}
