import 'package:flutter/material.dart';

class Appointment {
  final DateTime date;
  final String time;

  Appointment({required this.date, required this.time});
}

class DoctorDetailScreen extends StatefulWidget {
  final String name;
  final String image;
  final String availability;
  final String days;
  final double rating;
  final String city;

  DoctorDetailScreen({
    required this.name,
    required this.image,
    required this.availability,
    required this.days,
    required this.rating,
    required this.city,
  });

  @override
  _DoctorDetailScreenState createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  List<Appointment> appointments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              widget.image,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Availability: ${widget.availability}'),
                  Text('Days: ${widget.days}'),
                  Text('City: ${widget.city}'),
                  Row(
                    children: [
                      Text('Rating: '),
                      for (int i = 0; i < widget.rating.floor(); i++)
                        Icon(Icons.star, color: Colors.yellow[700]),
                      if (widget.rating - widget.rating.floor() > 0)
                        Icon(Icons.star_half, color: Colors.yellow[700]),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _showDateTimePicker(context);
                    },
                    child: Text('Book an Appointment'),
                  ),
                  SizedBox(height: 16),
                  appointments.isEmpty
                      ? Text(
                          'No appointments scheduled with ${widget.name}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Appointments with ${widget.name}:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: appointments.map((appointment) {
                                return Text(
                                  'booked up: ${appointment.date.toString().split(' ')[0]}, Time: ${appointment.time}',
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDateTimePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null) {
      if (pickedDate.weekday == DateTime.friday) {
        // Show a message that booking on Fridays is not allowed
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Booking Not Allowed'),
              content: Text('Booking on Fridays is not allowed.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Skip showing time picker and directly call _showTimeSlotDialog
        _showTimeSlotDialog(context, pickedDate, TimeOfDay(hour: 9, minute: 0));
      }
    }
  }

  void _showTimeSlotDialog(
      BuildContext context, DateTime pickedDate, TimeOfDay pickedTime) {
    List<String> timeSlots = [];
    // Generate available time slots based on pickedDate and pickedTime
    // Add morning time slots
    timeSlots.addAll([
      '9:00 AM - 10:00 AM',
      '10:00 AM - 11:00 AM',
      '11:00 AM - 12:00 PM',
    ]);
    // Add evening time slots
    timeSlots.addAll([
      '1:00 PM - 2:00 PM',
      '2:00 PM - 3:00 PM',
      '3:00 PM - 4:00 PM',
      '4:00 PM - 5:00 PM',
      '6:00 PM - 7:00 PM',
    ]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Time Slot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: timeSlots.map((slot) {
              return ListTile(
                title: Text(slot),
                onTap: () {
                  // Handle slot selection
                  _showConfirmationDialog(
                      context, pickedDate, pickedTime, slot);
                },
              );
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, DateTime pickedDate,
      TimeOfDay pickedTime, String selectedSlot) {
    // Check for existing appointments at the selected time
    bool hasConflict = appointments.any((appointment) =>
        appointment.date.year == pickedDate.year &&
        appointment.date.month == pickedDate.month &&
        appointment.date.day == pickedDate.day &&
        appointment.time == selectedSlot);

    if (hasConflict) {
      // Show a message that there is a scheduling conflict
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Scheduling Conflict'),
            content: Text(
                'There is already an appointment booked with ${widget.name} at $selectedSlot on ${pickedDate.toString().split(' ')[0]}.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Proceed with the appointment booking
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Appointment'),
            content: Text(
              'Are you sure you want to book an appointment with ${widget.name} on ${pickedDate.toString().split(' ')[0]} at $selectedSlot?',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Add the appointment to the list
                  appointments
                      .add(Appointment(date: pickedDate, time: selectedSlot));
                  Navigator.of(context).pop();
                  _showSuccessDialog(context);
                  setState(() {});
                },
                child: Text('Confirm'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Appointment booked successfully!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
