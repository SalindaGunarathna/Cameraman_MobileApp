// booking class 


import "address.dart";

class Booking {
  String bookingID;
  String eventDetails;
  String status;
  DateTime data;
  String clientName;
  String cameramanName;
  Address address;

  Booking(
    this.bookingID,
    this.eventDetails,
    this.status,
    this.data,
    this.clientName,
    this.cameramanName,
    this.address,
  );
}

