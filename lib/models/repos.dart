class Repos {
  final String name;

  Repos(this.name);

  Map<String, dynamic> toJson() => {
        'name': name,
      };

  Repos.fromJson(Map json) : name = json['name'];
}
