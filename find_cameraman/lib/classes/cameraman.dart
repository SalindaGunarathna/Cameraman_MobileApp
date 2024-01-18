
//cameraman class 

import 'project.dart';
import 'review.dart';
import 'user.dart';
import 'portfolio.dart';
//import 'review.dart';

class Cameraman extends User {
  String skill;
  Portfolio portfolio = Portfolio("C001", "Cameraman Portfolio", DateTime.now());
  List<String> _posts = [];
  List<Review> _reviews = [];
  bool avalible = false;


  Cameraman(
    String name,
    String userID,
    String phoneNumber,
    String emailAddress,
    String password,
    this.skill,
    String profileURL
  ) : super(name, userID, phoneNumber, emailAddress, password,profileURL);

  void addPost(String postContent) {
    _posts.add(postContent);
    print("Post added: $postContent");
  }

  List<String> getPosts() {
    return List<String>.from(_posts);
  }

    Map<String, dynamic> toJSON() {
    return {
      'userID': userID,
      'name': name,
      'emailAddress': emailAddress,
      'password': password,
      'phoneNumber': phoneNumber,
      'profileURL':profileURL
         
    };
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

  // Delegating Portfolio functions
  void addProject(Project project) {
    portfolio.addProject(project);
  }

  void removeProject(String project) {
    portfolio.removeProject(project);
  }

  void updateProjectDetails(String oldProject, String newProject) {
    portfolio.updateProjectDetails(oldProject, newProject);
  }

  List<Project> getAllProjects() {
    return portfolio.getAllProjects();
  }


  void addReview(Review review) {
    _reviews.add(review);
    print("Review added: ${review.comment}");
  }


   void removeReview(Review review) {
    if (_reviews.remove(review)) {
      print("Review removed: ${review.reviewID}");
    } else {
      print("Review not found: ${review.reviewID}");
    }
  }

    void updateReviewDetails(Review oldReview, Review newReview) {
    final index = _reviews.indexOf(oldReview);
    if (index != -1) {
      _reviews[index] = newReview;
      //print("Review details updated: $oldReview -> $newReview");
    } else {
      print("Review not found: ${oldReview.reviewID}");
    }
  }

  List<Review> getAllReviews() {
    return List<Review>.from(_reviews);
  }


}
