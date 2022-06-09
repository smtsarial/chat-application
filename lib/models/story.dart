class Story {
  late String id;
  late String ownerId;
  late String ownerMail;
  late String ownerUsername;
  late DateTime createdTime;
  late String ownerProfilePicture;
  late String imageUrl;
  late List seenPeople;
  late String ownerCity;
  late String ownerCountry;
  late String ownerGender;
  late int ownerAge;

  Story(
      this.id,
      this.ownerId,
      this.ownerMail,
      this.ownerUsername,
      this.ownerProfilePicture,
      this.createdTime,
      this.imageUrl,
      this.seenPeople,
      this.ownerAge,
      this.ownerCity,
      this.ownerCountry,
      this.ownerGender);
  Story.fromMap(dynamic obj) {
    ownerId = obj['ownerId'];
    ownerMail = obj['ownerMail'];
    ownerUsername = obj['ownerUsername'];
    ownerProfilePicture = obj['ownerProfilePicture'];
    createdTime = obj['createdTime'].toDate();
    imageUrl = obj['imageUrl'];
    seenPeople = obj['seenPeople'];
    ownerAge = obj['ownerAge'];
    ownerCity = obj['ownerCity'];
    ownerCountry = obj['ownerCountry'];
    ownerGender = obj['ownerGender'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['ownerId'] = this.ownerId;
      map['ownerMail'] = this.ownerMail;
      map['ownerUsername'] = this.ownerUsername;
      map['ownerProfilePicture'] = this.ownerProfilePicture;
      map['createdTime'] = this.createdTime;
      map['imageUrl'] = this.imageUrl;
      map['seenPeople'] = this.seenPeople;
      map['ownerAge'] = this.ownerAge;
      map['ownerCity'] = this.ownerCity;
      map['ownerCountry'] = this.ownerCountry;
      map['ownerGender'] = this.ownerGender;
    }
    return map;
  }
}

//class StoryViewer {
//  late String id;
//  late String ownerId;
//  late String ownerMail;
//  late String ownerUsername;
//  late DateTime createdTime;
//  late String ownerProfilePicture;
//  late String imageUrl;
//  late List seenPeople;
//  late String ownerCity;
//  late String ownerCountry;
//  late String ownerGender;
//  late int ownerAge;
//  late bool shown;
//  late Duration duration;
//
//  StoryViewer(
//      this.id,
//      this.ownerId,
//      this.ownerMail,
//      this.ownerUsername,
//      this.ownerProfilePicture,
//      this.createdTime,
//      this.imageUrl,
//      this.seenPeople,
//      this.ownerAge,
//      this.ownerCity,
//      this.ownerCountry,
//      this.ownerGender,
//      this.duration,
//      this.shown);
//  StoryViewer.fromMap(dynamic obj) {
//    ownerId = obj['ownerId'];
//    ownerMail = obj['ownerMail'];
//    ownerUsername = obj['ownerUsername'];
//    ownerProfilePicture = obj['ownerProfilePicture'];
//    createdTime = obj['createdTime'].toDate();
//    imageUrl = obj['imageUrl'];
//    seenPeople = obj['seenPeople'];
//    ownerAge = obj['ownerAge'];
//    ownerCity = obj['ownerCity'];
//    ownerCountry = obj['ownerCountry'];
//    ownerGender = obj['ownerGender'];
//    duration = obj['duration'];
//    shown = obj['shown'];
//  }
//
//  Map<String, dynamic> toMap() {
//    var map = Map<String, dynamic>();
//    if (id != null) {
//      map['ownerId'] = this.ownerId;
//      map['ownerMail'] = this.ownerMail;
//      map['ownerUsername'] = this.ownerUsername;
//      map['ownerProfilePicture'] = this.ownerProfilePicture;
//      map['createdTime'] = this.createdTime;
//      map['imageUrl'] = this.imageUrl;
//      map['seenPeople'] = this.seenPeople;
//      map['ownerAge'] = this.ownerAge;
//      map['ownerCity'] = this.ownerCity;
//      map['ownerCountry'] = this.ownerCountry;
//      map['ownerGender'] = this.ownerGender;
//      map['duration'] = this.duration;
//      map['shown'] = this.shown;
//    }
//    return map;
//  }
//}
