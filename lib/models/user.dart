class User {
  late String id;
  late String email;
  late int age;
  late int chatCount;
  late String profilePictureUrl;
  late List followers;
  late List followed;
  late String gender;
  late bool isActive;
  late DateTime lastActiveTime;
  late String firstName;
  late String lastName;
  late List likes;
  late String userBio;
  late List userTags;
  late String userType;
  late String username;
  late String country;
  late String city;
  late List myStoriesId;
  late List myYoutubeVideo;
  late List SpotifyList;
  late List MovieList;
  late List hobbies;
  late bool showStatus;
  late List blockedUsers;
  late String videoServicePassword;
  late int cubeid;
  late List myVoices;
  late bool canChangeUsername;

  User(
      this.id,
      this.email,
      this.age,
      this.chatCount,
      this.profilePictureUrl,
      this.followers,
      this.followed,
      this.gender,
      this.isActive,
      this.lastActiveTime,
      this.firstName,
      this.lastName,
      this.likes,
      this.userBio,
      this.userTags,
      this.userType,
      this.username,
      this.city,
      this.country,
      this.myStoriesId,
      this.myYoutubeVideo,
      this.SpotifyList,
      this.MovieList,
      this.hobbies,
      this.showStatus,
      this.blockedUsers,
      this.videoServicePassword,
      this.cubeid,
      this.myVoices,
      this.canChangeUsername);
  User.fromMap(dynamic obj) {
    email = obj['email'];
    firstName = obj['firstName'];
    followed = obj['followed'];
    username = obj['username'];
    userType = obj['userType'];
    userTags = obj['userTags'];
    userBio = obj['userBio'];
    likes = obj['likes'];
    lastName = obj['lastName'];
    lastActiveTime = obj['lastActiveTime'].toDate();
    isActive = obj['isActive'];
    gender = obj['gender'];
    followers = obj['followers'];
    profilePictureUrl = obj['profilePictureUrl'];
    chatCount = obj['chatCount'];
    age = obj['age'];
    city = obj['city'];
    country = obj['country'];
    myStoriesId = obj['myStoriesId'];
    myYoutubeVideo = obj['myYoutubeVideo'];
    SpotifyList = obj['SpotifyList'];
    MovieList = obj['MovieList'];
    hobbies = obj['hobbies'];
    showStatus = obj['showStatus'];
    blockedUsers = obj['blockedUsers'];
    videoServicePassword = obj['videoServicePassword'];
    cubeid = obj['cubeid'];
    myVoices = obj["myVoices"];
    canChangeUsername = obj["canChangeUsername"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['email'] = this.email;
      map['firstName'] = this.firstName;
      map['followed'] = this.followed;
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
      map['profilePictureUrl'] = this.profilePictureUrl;
      map['chatCount'] = this.chatCount;
      map['age'] = this.age;
      map['city'] = this.city;
      map['country'] = this.country;
      map['myStoriesId'] = this.myStoriesId;
      map['myYoutubeVideo'] = this.myYoutubeVideo;
      map['SpotifyList'] = this.SpotifyList;
      map['MovieList'] = this.MovieList;
      map['hobbies'] = this.hobbies;
      map['showStatus'] = this.showStatus;
      map['blockedUsers'] = this.blockedUsers;
      map["videoServicePassword"] = this.videoServicePassword;
      map["cubeid"] = this.cubeid;
      map["myVoices"] = this.myVoices;
      map["canChangeUsername"] = this.canChangeUsername;
    }
    return map;
  }
}
