class Repos {
  final String name;
  final String htmlUrl;

  Repos(this.name, this.htmlUrl);

  Map<String, dynamic> toJson() => {
        'name': name,
        'html_url': htmlUrl,
      };

  Repos.fromJson(Map json)
      : name = json['name'],
        htmlUrl = json['html_url'];
}
