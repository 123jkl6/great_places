import "dart:io";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:great_places/widgets/image_input.dart';
import "package:great_places/providers/great_places_provider.dart";

class AddPlaceScreen extends StatefulWidget {
  static const routeName = "/add-place";
  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File _pickedImage;

  void _selectImage(File pickedImage){
    _pickedImage = pickedImage; 
  }

  void _savePlace(){
    if (_titleController.text.isEmpty || _pickedImage == null){
      return;
    }
    Provider.of<GreatPlaces>(context,listen:false).addPlace(_titleController.text.trim(), _pickedImage);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add a New Place"),
        ),
        body: Column(
          //no need spaceBetween because of Expanded widget
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //take full width
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text("User Inputs..."),
            //nested Column and Expanded
            Expanded(
              //make it scrollable
              child: SingleChildScrollView(
                child: Padding(
                  //to make sure fields don't sit at edge of device.
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(labelText: "Title"),
                        controller:_titleController,
                      ),
                      SizedBox(height:10,), 
                      ImageInput(selectImage:_selectImage),
                    ],
                  ),
                ),
              ),
            ),
            //contains both label and icon
            RaisedButton.icon(
              icon: Icon(Icons.add),
              label: Text("Add Place"),
              onPressed: _savePlace,
              elevation: 0,
              //remove margin, so button sits right at the bottom with no gap.
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ));
  }
}
