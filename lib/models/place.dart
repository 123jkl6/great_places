import "dart:io";
import "package:flutter/foundation.dart";

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  //constructor does not change at runtime. 
  const PlaceLocation({
    @required this.latitude,
    @required this.longitude,
    this.address, //just the human readable part, not required in all cases. 
  });
}

class Place {
  final String id;
  final String title;
  final location;
  final File image;

  Place({
    @required this.id,
    @required this.title,
    @required this.location,
    @required this.image,
  });
}
