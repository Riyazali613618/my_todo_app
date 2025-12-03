class User {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;

  const User({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  factory User.fromMap(Map<String, dynamic> map) => User(
    uid: map['uid'],
    email: map['email'],
    displayName: map['displayName'],
    photoUrl: map['photoUrl'],
  );

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
  };
}
