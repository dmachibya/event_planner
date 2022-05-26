class Ukumbi{
  final String category;
  final String about;
  final String location;
  final bool isBooked;
  final String isBookedDate;
  final String name;
  final Map<String,dynamic> image;
  final String uid;
  static List<String> categories = ['Sherehe','Mkutano'];
  const Ukumbi({required this.isBookedDate,required this.isBooked,required this.location,required this.about,required this.category,required this.image,required this.name,required this.uid});

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