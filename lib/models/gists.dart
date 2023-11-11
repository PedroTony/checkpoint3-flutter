class Gists {
  final String htmlUrl;
  final String filename;

  Gists(this.htmlUrl, this.filename);

  Map<String, dynamic> toJson() => {'html_url': htmlUrl, 'filename': filename};

  Gists.fromJson(Map json)
      : htmlUrl = json['html_url'],
        filename = json['files'].values.isNotEmpty
            ? json['files'].values.first['filename']
            : null;
}
