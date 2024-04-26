class Place {
 
  String name;
  String imagePath;
  String desc;
 
  Place({
    required this.name,
    required this.imagePath,
    required this.desc
  });
 
  String getFolderPath() => "images/$imagePath.jpg";
}