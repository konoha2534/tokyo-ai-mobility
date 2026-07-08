import 'package:latlong2/latlong.dart';

import '../models/place.dart';

const tokyoPlaces = [
  Place(
    id: 'tokyo-metropolitan-gov',
    name: '東京都庁',
    address: '東京都新宿区',
    point: LatLng(35.6895, 139.6917),
  ),
  Place(
    id: 'tokyo-medical-university',
    name: '東京医科大学病院',
    address: '東京都新宿区西新宿',
    point: LatLng(35.6938, 139.6998),
  ),
  Place(
    id: 'shinjuku-station',
    name: '新宿駅',
    address: '東京都新宿区',
    point: LatLng(35.6909, 139.7003),
  ),
  Place(
    id: 'shibuya-station',
    name: '渋谷駅',
    address: '東京都渋谷区',
    point: LatLng(35.6580, 139.7016),
  ),
  Place(
    id: 'tokyo-station',
    name: '東京駅',
    address: '東京都千代田区丸の内',
    point: LatLng(35.6812, 139.7671),
  ),
];

const departureTimes = ['18:30', '19:00', '19:30', '20:00'];
