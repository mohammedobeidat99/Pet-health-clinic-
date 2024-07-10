import 'package:flutter/material.dart';
import 'package:pethhealth/constant/list.dart';
import 'package:pethhealth/widget/custom_doctor_card.dart';



class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? selectedCity;
  bool showAllContent = false;
  bool sortByRating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Veterinary Doctor',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.filter_list_sharp,
              color: Colors.white,
            ),
            //color: Colors.white,
            onSelected: (value) {
              setState(() {
                if (value == 'Sort by Rating') {
                  sortByRating = true;
                } else if (value == 'Show All') {
                  showAllContent = true;
                } else {
                  sortByRating = false;
                  selectedCity = value;
                  showAllContent = false; // Reset to show filtered content
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: 'Show All',
                child: Text('Show All'),
              ),
              const PopupMenuItem(
                value: 'Irbid',
                child: Text('Filter by Irbid'),
              ),
              const PopupMenuItem(
                value: 'Amman',
                child: Text('Filter by Amman'),
              ),
              const PopupMenuItem(
                value: 'Sort by Rating',
                child: Text('Sort by Rating'),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          // Filter doctors based on selected city and rating sorting
          if (showAllContent ||
              (selectedCity == null ||
                  doctors[index]['city'].toLowerCase() ==
                      selectedCity!.toLowerCase()) &&
                  (!sortByRating || doctors[index]['rating'] >= 4.0)) {
            return DoctorCard(
              name: doctors[index]['name'],
              image: doctors[index]['image'],
              availability: doctors[index]['availability'],
              days: doctors[index]['days'],
              rating: doctors[index]['rating'],
              city: doctors[index]['city'],
            );
          } else {
            return const SizedBox.shrink(); // Hide doctors that don't meet filter criteria
          }
        },
      ),
    );
  }
}
