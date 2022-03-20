class User {
  late String id;
  late int age;
  late int chatCount;
  late String profilePictureUrl;
  late List followers;
  late String gender;
  late bool isActive;
  late DateTime lastActiveTime;
  late String lastName;
  late List likes;
  late String userBio;
  late List userTags;
  late String userType;
  late String username;

  User(
    this.id,
    this.age,
    this.chatCount,
    this.profilePictureUrl,
    this.followers,
    this.gender,
    this.isActive,
    this.lastActiveTime,
    this.lastName,
    this.likes,
    this.userBio,
    this.userTags,
    this.userType,
    this.username,
  );
  User.fromMap(dynamic obj) {
    username = obj['username'];
    userType = obj['userType'];
    userTags = obj['userTags'];
    userBio = obj['userBio'];
    likes = obj['likes'];
    lastName = obj['lastName'];
    lastActiveTime = obj['lastActiveTime'];
    isActive = obj['isActive'];
    gender = obj['gender'];
    followers = obj['followers'];
    profilePictureUrl = obj['profilePictureUrl'];
    chatCount = obj['chatCount'];
    age = obj['age'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['username'] = this.username;
      map['userType'] = this.userType;
      map['userTags'] = this.userTags;
      map['userBio'] = this.userBio;
      map['likes'] = this.likes;
      map["lastName"] = this.lastName;
      map['lastActiveTime'] = this.lastActiveTime;
      map['isActive'] = this.isActive;
      map["gender"] = this.gender;
      map['followers'] = this.followers;
      map['profilePitureUrl'] = this.profilePictureUrl;
      map['chatCount'] = this.chatCount;
      map['age'] = this.age;
    }
    return map;
  }
}
