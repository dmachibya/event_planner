class Ukumbi{
  final String category;
  final String about;
  final String location;
  final String name;
  final String image;
  final String uid;
  static List<String> categories = ['Sherehe','Mkutano'];
  const Ukumbi({required this.location,required this.about,required this.category,required this.image,required this.name,required this.uid});

}

class Event{
  final String name;
  final String about;
  final String image;
  final String uid;
  final String date;
  final String category;
  final String location;
  Event({ required this.date,required this.about,required this.category,required this.image,required this.location,required this.name,required this.uid});
}