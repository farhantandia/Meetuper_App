class userCategory {
  final String id;
  final String name;
  final String image;

  userCategory.fromJSON(Map<String, dynamic> parsedJson)
      : this.id = parsedJson['_id'],
        this.name = parsedJson['name'] ?? '',
        this.image = parsedJson['image'] ?? '';

  Map<String, dynamic> toJSON() => {'_id': id, 'name': name, 'image': image};
  @override
  String toString() {
    return name;
  }
}
