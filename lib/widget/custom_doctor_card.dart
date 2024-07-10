import 'package:flutter/material.dart';
import 'package:pethhealth/screen/home/vet/detail_screen.dart';

class DoctorCard extends StatelessWidget {
  final String name;
  final String image;
  final String availability;
  final String days;
  final double rating;
  final String city;

  DoctorCard({
    required this.name,
    required this.image,
    required this.availability,
    required this.days,
    required this.rating,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          // Navigate to the doctor detail screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorDetailScreen(
                name: name,
                image: image,
                availability: availability,
                days: days,
                rating: rating,
                city: city,
              ),
            ),
          );
        },
        leading: Container( 
          height: double.infinity,//maxRadius: 50,
          child: Image.asset(image),
        ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Availability: $availability'),
            Text('Days: $days'),
            Text('City: $city'),
            Row(
              children: [
                Text('Rating: '),
                for (int i = 0; i < rating.floor(); i++)
                  Icon(Icons.star, color: Colors.yellow[700] ),
                if (rating - rating.floor() > 0)
                  Icon(Icons.star_half, color: Colors.yellow[700]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
