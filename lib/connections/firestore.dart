import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebasedeneme/connections/auth.dart';
import 'package:firebasedeneme/helper.dart';
import 'package:firebasedeneme/models/story.dart';
import 'package:firebasedeneme/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class FirestoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final DatabaseReference ref = FirebaseDatabase.instance.ref();

  static Future deneme() async {
    await Authentication().login("sarialsamet@gmail.com", "samet2828");
    Stream<DatabaseEvent> stream =
        ref.child("asfasf/messages/sendermessager").orderByValue().onValue;
    stream.listen((DatabaseEvent event) {
      var data = event.snapshot.value;
      print(data);
    });
  }

  static Future<int> checkUsername(username) async {
    //this function checks usernames from users collection
    try {
      var data = await db
          .collection('users')
          .where("username", isEqualTo: username)
          .get();
      print(data.size);
      return data.size;
    } catch (e) {
      print(e);
      return -99;
    }
  }

  static Future uploadProfilePictureToStorage(path) async {
    try {
      String? pictureUrl;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profileImages/${Path.basename(path.toString())}');

      await ref.putFile(path).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          print(pictureUrl);
          pictureUrl = value;
          print(pictureUrl);
        });
      });
      return pictureUrl;
    } catch (e) {
      return e;
    }
  }

  static Future<List<Story>> FakeStory() async {
    final Faker faker = Faker();
    final date = Helpers.randomDate();
    List<Story> stories = [];
    print(faker.address.city());
    for (int i = 0; i < 100; i++) {
      stories.add(Story("", faker.phoneNumber.random.toString(),
          faker.food.dish().toString(), date, Faker().image.image(), []));
    }
    return stories;
  }

  static Future<bool> addNewUser(
    id,
    age,
    chatCount,
    profilePictureUrl,
    followers,
    gender,
    isActive,
    lastActiveTime,
    lastName,
    likes,
    userBio,
    userTags,
    userType,
    username,
  ) async {
    //this function will add new user to users collection
    try {
      var result = await db.collection('users').add(User(
              id,
              age,
              chatCount,
              profilePictureUrl,
              followers,
              gender,
              isActive,
              lastActiveTime,
              lastName,
              likes,
              userBio,
              userTags,
              userType,
              username,
              "Türkiye",
              "İstanbul")
          .toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
