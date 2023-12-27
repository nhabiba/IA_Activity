class Activity {
  final String title;
  final double price;
  final String location;
  final String category;
  final int minParticipants;
  final String imageUrl;

  Activity({
    required this.title,
    required this.price,
    required this.location,
    required this.category,
    required this.minParticipants,
    required this.imageUrl,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      title: json['title'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      location: json['location'] ?? '',
      category: json['category'] ?? '',
      minParticipants: json['minParticipants'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}