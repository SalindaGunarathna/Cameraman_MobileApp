// user class 
import "address.dart";


class User {
  String name;
  String userID;
  String phoneNumber;
  String emailAddress;
  String password;
  String? profileURL;
  Address? address;

  User(
    this.name,
    this.userID,
    this.phoneNumber,
    this.emailAddress,
    this.password,
    this.profileURL
  );

  void addAddress(
    String street,
    String city,
    String state,
    String postalCode,
    String country,
  ) {
    address = Address(street, city, state, postalCode, country);
  }
}
