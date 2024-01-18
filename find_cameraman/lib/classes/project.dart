class Project {
  String projectName;
  List<String> album = [];
  String? description;
  String? cameramanId;
  String? cameramanName;
  String? cameramanEmail;
  String? projectDate;

  Project(
    this.projectName, {
    this.cameramanId,
    this.cameramanName,
    this.cameramanEmail,
    this.projectDate,
    this.description
    
});

  void addImage(String image) {
    album.add(image);
  }

  void removeImage(String image) {
    int index = album.indexOf(image);
    if (index != -1) album.removeAt(index);
  }

  void updateImage(String oldImage, String newImage) {
    final index = album.indexOf(oldImage);
    if (index != -1) {
      album[index] = newImage;
      print("Project details updated: $oldImage -> $newImage");
    } else {
      print("Project not found: $oldImage");
    }
  }

  List<String> retrieveImage() {
    return List<String>.from(album);
  }
}
