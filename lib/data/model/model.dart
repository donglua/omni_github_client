class User {
  final String login;
  final int id;
  final String avatarUrl;
  final String name;
  final String bio;

  User(
      {this.login = "",
      this.id,
      this.avatarUrl = "",
      this.name = "unknown",
      this.bio = ""});

  factory User.initialFrom(dynamic map) => User(
        login: map['login'],
        id: map['id'],
        avatarUrl: map['avatar_url'],
        name: map['name'],
        bio: map['bio'],
      );
}
