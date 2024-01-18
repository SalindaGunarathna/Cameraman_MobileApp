import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_cameraman/classes/address.dart';
import 'package:find_cameraman/classes/booking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClientBooking
 extends StatefulWidget {
  const ClientBooking
  ({super.key});

  @override
  State<ClientBooking
  > createState() => _ClientHomepageState();
}

class _ClientHomepageState extends State<ClientBooking
> {
  final user = FirebaseAuth.instance.currentUser;
  String? _name;

  // Text controllers for input fields
  final TextEditingController eventDetailsController = TextEditingController();
  final TextEditingController cameramanNameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<void> _getUserName() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot = await firestore
        .collection("clients")
        .where("email", isEqualTo: user!.email)
        .get();
    final List<DocumentSnapshot> documents = querySnapshot.docs;
    if (documents.isNotEmpty) {
      final DocumentSnapshot document = documents.first;
      _name = document["name"];
      setState(() {});
    }
  }

  Future<void> _addBooking(Booking booking) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Add the booking to the "bookings" collection
      await firestore.collection("bookings").add({
        'bookingID': booking.bookingID,
        'eventDetails': booking.eventDetails,
        'status': booking.status,
        'data': booking.data,
        'clientName': booking.clientName,
        'cameramanName': booking.cameramanName,
        'address': {
          'street': booking.address.street,
          'city': booking.address.city,
          'state': booking.address.state,
          'postalCode': booking.address.postalCode,
          'country': booking.address.country,
        },
        'clientEmail': user!.email,
      });
    } catch (e) {
      print("Error adding booking: $e");
    }
  }

  Future<void> _addNewBooking() async {
    // Create a Booking object with the required information
    Booking newBooking = Booking(
      "123456", // replace with a unique booking ID logic
      eventDetailsController.text,
      "Pending",
      DateTime.now(),
      _name ?? "",
      cameramanNameController.text,
      Address(
        streetController.text,
        cityController.text,
        stateController.text,
        postalCodeController.text,
        countryController.text,
      ),
    );

    // Call the method to add the booking
    await _addBooking(newBooking);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Homepage'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Client Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Name: $_name'),
              SizedBox(height: 20),
              Text(
                'Booking Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: eventDetailsController,
                decoration: InputDecoration(labelText: 'Event Details'),
              ),
              TextField(
                controller: cameramanNameController,
                decoration: InputDecoration(labelText: 'Cameraman Name'),
              ),
              SizedBox(height: 20),
              Text(
                'Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: streetController,
                decoration: InputDecoration(labelText: 'Street'),
              ),
              TextField(
                controller: cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              TextField(
                controller: stateController,
                decoration: InputDecoration(labelText: 'State'),
              ),
              TextField(
                controller: postalCodeController,
                decoration: InputDecoration(labelText: 'Postal Code'),
              ),
              TextField(
                controller: countryController,
                decoration: InputDecoration(labelText: 'Country'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addNewBooking,
                child: Text('Add Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
