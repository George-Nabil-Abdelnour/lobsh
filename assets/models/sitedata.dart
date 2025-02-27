class SiteModel {
  final String id;
  final String siteName;
  final String siteUrl;
  final String username;
  final String email;
  final String phone;
  final String password;

  SiteModel({
    required this.id,
    required this.siteName,
    required this.siteUrl,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'siteName': siteName,
      'siteUrl': siteUrl,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  static SiteModel fromMap(Map<String, dynamic> map) {
    return SiteModel(
      id: map['id'],
      siteName: map['siteName'],
      siteUrl: map['siteUrl'],
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
    );
  }
}
