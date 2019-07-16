import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/helpers/location_helper.dart';
import 'package:great_places/screens/map_screen.dart';
import "package:location/location.dart";

class LocationInput extends StatefulWidget {
  final Function selectPlace;

  LocationInput({this.selectPlace});

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      print("lat : " + locData.latitude.toString());
      print("long : " + locData.longitude.toString());
      _showPreview(locData.latitude, locData.longitude);
      widget.selectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    //indicate type because flutter is not aware of type
    final LatLng selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(isSelecting: true),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.selectPlace(selectedLocation.latitude, selectedLocation.longitude);
    print("lat : " + selectedLocation.latitude.toString());
    print("long : " + selectedLocation.longitude.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          alignment: Alignment.center,
          child: _previewImageUrl == null
              ? Text("No location input", textAlign: TextAlign.center)
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.location_on),
              label: Text("Current Location"),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getCurrentUserLocation,
            ),
            FlatButton.icon(
              icon: Icon(Icons.map),
              label: Text("Select Map."),
              textColor: Theme.of(context).primaryColor,
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
