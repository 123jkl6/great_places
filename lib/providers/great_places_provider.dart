import "dart:io";
import 'package:flutter/foundation.dart';

import "../helpers/db_helper.dart";
import "../helpers/location_helper.dart";
import "../models/place.dart";

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place)=>place.id==id);
  }

  Future<void> addPlace(
      String title, File image, PlaceLocation pickedLocation) async {
    final String humanReadableAddress = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final updatedLocation = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: humanReadableAddress);

    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      title: title,
      location: updatedLocation,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert("USER_PLACES", {
      "id": newPlace.id,
      "title": title,
      "image": newPlace.image.path,
      "loc_lat": updatedLocation.latitude,
      "loc_lng": updatedLocation.longitude,
      "address": updatedLocation.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData("USER_PLACES");
    _items = dataList
        .map(
          (item) => Place(
            id: item["id"],
            title: item["title"],
            image: File(item["image"]),
            location: PlaceLocation(
              latitude: item["loc_lat"],
              longitude: item["loc_lng"],
              address: item["address"],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }
}
