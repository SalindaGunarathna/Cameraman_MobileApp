// client class inherited by user

import 'booking.dart';
import 'user.dart';

import 'address.dart';

class Client extends User {
  String _budgetRange = "null";
  List<Booking> bookings = [];
  String? profileURL;

  Client({
    required String name,
    required String userID,
    required String phoneNumber,
    required String emailAddress,
    required String password,
    required String profileURL,
  }) : super(name, userID, phoneNumber, emailAddress, password, profileURL);

  void setBudget(String budgetRange) {
    this._budgetRange = budgetRange;
  }

  Map<String, dynamic> toJSON() {
    return {
      'userID': userID,
      'name': name,
      'emailAddress': emailAddress,
      'password': password,
      'phoneNumber': phoneNumber,
      'profileURL': profileURL
    };
  }

  // when we get data from firebase we get it in the form of map
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      userID: json['userID'] as String,
      name: json['name'] as String,
      emailAddress: json['emailAddress'] as String,
      password: json['password'] as String,
      phoneNumber: json[' phoneNumber'] as String,
      profileURL: json['profileURL'] as String,
    );
  }

  String getBudget() {
    return this._budgetRange;
  }

  void newAddress(
    String street,
    String city,
    String state,
    String postalCode,
    String country,
  ) {
    addAddress(street, city, state, postalCode, country);
  }

  void addBooking(
    String bookingID,
    String eventDetails,
    String status,
    DateTime date,
    String client,
    String camaraman,
    Address address,
  ) {
    final newBooking = Booking(
        bookingID, eventDetails, status, date, client, camaraman, address);
    bookings.add(newBooking);
  }

  void deleteBooking(String bookingID) {
    bookings.removeWhere((booking) => booking.bookingID == bookingID);
  }

  List<Booking> getAllBookings() {
    return List<Booking>.from(bookings);
  }
}
