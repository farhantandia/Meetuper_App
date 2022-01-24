class userCategory {
  final String id;
  final String name;
  final String image;

  userCategory.fromJSON(Map<String, dynamic> parsedJson)
      : this.id = parsedJson['_id'],
        this.name = parsedJson['name'] ?? '',
        this.image = parsedJson['image'] ?? '';

}