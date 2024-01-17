
// client class inherited by user 

import 'booking.dart';
import 'user.dart';

import 'address.dart';


class Client extends User {
  String _budgetRange = "null";
  List<Booking> bookings = [];
   String? profileURL;
 

  Client(
    String name,
    String userID,
    String phoneNumber,
    String emailAddress,
    String password,
   
  ) : super(name, userID, phoneNumber, emailAddress, password);

  void setBudget(String budgetRange) {
    this._budgetRange = budgetRange;
  }

  String  getBudget (){
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
    final newBooking = Booking(bookingID, eventDetails, status, date, client, camaraman, address);
    bookings.add(newBooking);
  }

  void deleteBooking(String bookingID) {
    bookings.removeWhere((booking) => booking.bookingID == bookingID);
  }

  List<Booking> getAllBookings() {
    return List<Booking>.from(bookings);
  }

  
}


