import "dart:io";
import 'package:flutter/foundation.dart';

import "../helpers/db_helper.dart";
import "../models/place.dart";

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  addPlace(String title, File image) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      title: title,
      location: null,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert("USER_PLACES", {
      "id": newPlace.id,
      "title": title,
      "image": newPlace.image.path,
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
              location: null),
        )
        .toList();
    notifyListeners();
  }
}
