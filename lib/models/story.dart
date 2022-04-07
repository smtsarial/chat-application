class Story {
  late String id;
  late String ownerMail;
  late String ownerUsername;
  late DateTime createdTime;
  late String ownerProfilePicture;
  late String imageUrl;
  late List seenPeople;

  Story(
    this.id,
    this.ownerMail,
    this.ownerUsername,
    this.ownerProfilePicture,
    this.createdTime,
    this.imageUrl,
    this.seenPeople,
  );
  Story.fromMap(dynamic obj) {
    ownerMail = obj['ownerMail'];
    ownerUsername = obj['ownerUsername'];
    ownerProfilePicture = obj['ownerProfilePicture'];
    createdTime = obj['createdTime'].toDate();
    imageUrl = obj['imageUrl'];
    seenPeople = obj['seenPeople'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['ownerMail'] = this.ownerMail;
      map['ownerUsername'] = this.ownerUsername;
      map['ownerProfilePicture'] = this.ownerProfilePicture;
      map['createdTime'] = this.createdTime;
      map['imageUrl'] = this.imageUrl;
      map['seenPeople'] = this.seenPeople;
    }
    return map;
  }
}
