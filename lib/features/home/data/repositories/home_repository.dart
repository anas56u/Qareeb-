import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../models/cafe_model.dart';

class HomeRepository {
  final FirebaseFirestore _firestore;

  HomeRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Position> getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Location services are disabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<List<CafeModel>> getCafes() async {
    final Position userPos = await getUserLocation();

    final snapshot = await _firestore.collection('cafes').get();

    List<CafeModel> cafes = snapshot.docs.map((doc) {
      return CafeModel.fromMap(doc.id, doc.data());
    }).toList();

    for (var cafe in cafes) {
      double distanceInMeters = Geolocator.distanceBetween(
        userPos.latitude,
        userPos.longitude,
        cafe.latitude,
        cafe.longitude,
      );
      cafe.distance = distanceInMeters / 1000; 
    }

    cafes.sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));

    return cafes;
  }
}