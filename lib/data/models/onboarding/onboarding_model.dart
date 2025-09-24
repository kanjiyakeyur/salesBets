
class OnboardingModel {
  String? title;
  String description;
  String imagePath;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  OnboardingModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        imagePath = json['imagePath'];

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imagePath': imagePath,
    };
  }
}