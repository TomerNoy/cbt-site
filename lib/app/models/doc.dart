enum DocType { article, other }

class Doc {
  final String name;
  final String content;
  final String sha;
  final DocType type;

  Doc({
    required this.content,
    required this.sha,
    required this.name,
    required this.type,
  });

  Doc.fromMap(Map<String, dynamic> json)
      : content = json['content'] as String,
        sha = (json['sha'] as String),
        name = json['name'] as String,
        type = switch (json['type'] as String) {
          'article' => DocType.article,
          _ => DocType.other,
        };

  Map<String, dynamic> toMap() => {
        'content': content,
        'sha': sha,
        'name': name,
        'type': type.name,
      };

  @override
  String toString() {
    return 'Doc{name: $name, sha: $sha, type: $type}';
  }
}
