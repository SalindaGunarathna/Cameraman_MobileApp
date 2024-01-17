//Portfolio class
import 'project.dart';

class Portfolio {
  String portfolioID;
  String description;
  DateTime dateAdded;
  List<Project> projects = [];

  Portfolio(
    this.portfolioID,
    this.description,
    this.dateAdded,
  );

  void addProject(Project project) {
    projects.add(project);
    print("Project added: ${project.projectName}");
  }

  void removeProject(String projectName) {
  int index = -1;
  for (int i = 0; i < projects.length; i++) {
    if (projects[i].projectName == projectName) {
      index = i;
      break;
    }
  }
  if (index != -1) {
    Project removedProject = projects.removeAt(index);
    print("Project removed: ${removedProject.projectName}");
  } else {
    print("Project not found: $projectName");
  }
}

void updateProjectDetails(String oldProjectName, String newProjectName) {
  for (int i = 0; i < projects.length; i++) {
    if (projects[i].projectName == oldProjectName) {
      projects[i].projectName = newProjectName;
      print("Project details updated: $oldProjectName -> $newProjectName");
      return;
    }
  }
  print("Project not found: $oldProjectName");
}


  List<Project> getAllProjects() {
  return List<Project>.from(projects);
}

}
