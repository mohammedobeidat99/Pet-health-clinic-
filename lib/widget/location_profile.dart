import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Icon(Icons.my_location),
      title: Text("Location"),
      subtitle: FutureBuilder<String>(
        future: _getCurrentLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Text(snapshot.data ?? 'Unknown');
          }
        },
      ),
      onTap: () async {
        String currentLocation = await _getCurrentLocation();
        if (currentLocation != null) {
          await _uploadLocationToFirestore(currentLocation);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Location uploaded to Firestore!'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to get location.'),
            ),
          );
        }
      },
    );
  }

  Future<String> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return "${position.latitude},${position.longitude}";
    } catch (e) {
      print("Error getting location: $e");
      return '';
    }
  }

  Future<void> _uploadLocationToFirestore(String location) async {
    try {
      await FirebaseFirestore.instance.collection('locations').add({
        'location': location,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error uploading location to Firestore: $e");
    }
  }
}