// ignore_for_file: unnecessary_null_comparison, unused_local_variable

import 'package:anonmy/models/message_data.dart';
import 'package:anonmy/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:anonmy/connections/auth.dart';
import 'package:anonmy/models/story.dart';
import 'package:anonmy/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class FirestoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final DatabaseReference ref = FirebaseDatabase.instance.ref();

  static Future<User> getUserData() async {
    //this method for taking user data
    List<User> details = [];

    await Authentication().getUser().then((value) async {
      if (value != null) {
        if (value.isNotEmpty) {
          var data = await db.collection('users').where("email", isEqualTo: value.toString()).get();
          if (data != null) {
            details = data.docs.map((document) => User.fromMap(document)).toList();
          }
          int i = 0;
          details.forEach((detail) {
            detail.id = data.docs[i].id;
            i++;
          });
        }
      }
    });

    return details.length != 0 ? details[0] : emptyUser;
  }

  static Future<User> getSpecificUserInfo(String mail) async {
    //this method for taking user data
    List<User> details = [];
    var data = await db.collection('users').where("email", isEqualTo: mail.toString()).get();
    if (data != null) {
      details = data.docs.map((document) => User.fromMap(document)).toList();
    }
    int i = 0;
    details.forEach((detail) {
      detail.id = data.docs[i].id;
      i++;
    });

    return details.length != 0 ? details[0] : emptyUser;
  }

  static Future<User> getSpecificUserInfoByCubeId(int cubeId) async {
    //this method for taking user data
    List<User> details = [];
    var data = await db.collection('users').where("cubeid", isEqualTo: cubeId).get();
    if (data != null) {
      details = data.docs.map((document) => User.fromMap(document)).toList();
    }
    int i = 0;
    details.forEach((detail) {
      detail.id = data.docs[i].id;
      i++;
    });

    return details.length != 0 ? details[0] : emptyUser;
  }

  static Future<bool> changeToOfflineStatus() async {
    //change to user status
    try {
      FirestoreHelper.getUserData().then((value) async {
        await db.collection('users').doc(value.id).update({'isActive': false, 'lastActiveTime': DateTime.now()});
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> unfollowUser(User user, User removedUser) async {
    //UNFOLLOW USER
    try {
      FirestoreHelper.getUserData().then((value) {
        db.collection('users').doc(value.id).update({
          'followers': FieldValue.arrayRemove([removedUser.username])
        });
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> removeFollowedUser(userId, removedData) async {
    //REMOVES FROM FOLLOWED LIST
    try {
      FirestoreHelper.getUserData().then((value) {
        db.collection('users').doc(userId).update({
          'followed': FieldValue.arrayRemove([removedData])
        });
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> addFollowersToUser(User follower, User user) async {
    //follow user
    try {
      FirestoreHelper.getUserData().then((value) {
        db.collection('users').doc(value.id).update({
          'followers': FieldValue.arrayUnion([follower.username])
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<int> checkUsername(username) async {
    //this function checks usernames from users collection
    try {
      var data = await db.collection('users').where("username", isEqualTo: username).get();
      print(data.size);
      return data.size;
    } catch (e) {
      print(e);
      return -99;
    }
  }

  static Future uploadChatImagesToStorage(path) async {
    //upload profile picture
    try {
      String? pictureUrl;
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child('chatPhotos/${Path.basename(path.toString())}');

      await ref.putFile(path).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          print(pictureUrl);
          pictureUrl = value;
          print(pictureUrl);
        });
      });
      return pictureUrl;
    } catch (e) {
      print("sss" + e.toString());
      return e;
    }
  }

  static Future uploadProfilePictureToStorage(path) async {
    //upload profile picture
    try {
      String? pictureUrl;
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child('profileImages/${Path.basename(path.toString())}');

      await ref.putFile(path).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          print(pictureUrl);
          pictureUrl = value;
          print(pictureUrl);
        });
      });
      return pictureUrl;
    } catch (e) {
      print("sss" + e.toString());
      return e;
    }
  }

  static Future<bool> saveNewStories(String storyUrl) async {
    try {
      await FirestoreHelper.getUserData().then((value) async {
        Story story = Story("", value.email, value.username, value.profilePictureUrl, DateTime.now(), storyUrl, [], value.age, value.city,
            value.country, value.gender);
        await db.collection('stories').add(story.toMap()).then((value1) {
          print(value1.id);
          db.collection('users').doc(value.id).update({
            "myStoriesId": FieldValue.arrayUnion([value1.id])
          });
        });
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future uploadStoryToStorage(path) async {
    //upload story picture
    try {
      String? pictureUrl;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('stories/${Path.basename(path.toString())}');

      await ref.putFile(path).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          pictureUrl = value;
        });
      });

      return pictureUrl;
    } catch (e) {
      return e;
    }
  }

  static Future<List<Story>> getStoriesForUser(User userData) async {
    //Gets all stories

    List<Story> stories = [];
    await db
        .collection('stories')
        .where("ownerMail", isEqualTo: userData.email)
        .orderBy("createdTime", descending: false)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        stories.add(Story.fromMap(element));
      });
      int i = 0;
      stories.forEach((detail) {
        detail.id = value.docs[i].id;
        i++;
      });
    });
    return stories;
  }

  static Future<List<Story>> getStoriesForStoryScreen() async {
    //Gets all stories
    List<Story> stories = [];
    await db.collection('stories').get().then((value) {
      value.docs.forEach((element) {
        stories.add(Story.fromMap(element));
      });
    });
    return stories;
  }

  static Future<bool> sendMessageNormally(receiverMail, receiverUsername, receiverCubeId, receiverProfilePictureUrl, anon) async {
    try {
      await FirestoreHelper.getUserData().then((value) async {
        await db.collection('messages').add({
          'acceptAllMedia': false,
          'anonim': anon,
          "lastMessageTime": DateTime.now(),
          "receiverMail": receiverMail,
          "receiverProfilePictureUrl": receiverProfilePictureUrl,
          "receiverUsername": receiverUsername,
          "senderMail": value.email,
          "senderProfilePictureUrl": value.profilePictureUrl,
          "senderUsername": value.username,
          "lastMessage": "",
          "MessageRoomPeople": [receiverMail, value.email],
          "senderCubeId": value.cubeid,
          "receiverCubeId": receiverCubeId
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<MessageRoom> getSpecificChatRoomInfo(id) async {
    MessageRoom message = MessageRoom("", [], "", "", "", "", "", "", DateTime.now(), "", true, false, 0, 0);
    try {
      await db.collection('messages').doc(id).get().then((data) {
        message = MessageRoom(
            id,
            data['MessageRoomPeople'],
            data['senderMail'],
            data['senderUsername'],
            data['senderProfilePictureUrl'],
            data['receiverMail'],
            data['receiverProfilePictureUrl'],
            data['receiverUsername'],
            data['lastMessageTime'].toDate(),
            data['lastMessage'],
            data['anonim'],
            data['acceptAllMedia'],
            data['senderCubeId'],
            data['receiverCubeId']);
      });
      return message;
    } catch (e) {
      return message;
    }
  }

  static Future<String> addNewMessageRoom(bool anonOrNot, User sender, User receiver) async {
    //send message to specific user
    String id = "";
    try {
      await db.collection('messages').add({
        'acceptAllMedia': false,
        'anonim': anonOrNot,
        "lastMessageTime": DateTime.now(),
        "receiverMail": receiver.email,
        "receiverProfilePictureUrl": receiver.profilePictureUrl,
        "receiverUsername": receiver.username,
        "senderMail": sender.email,
        "senderProfilePictureUrl": sender.profilePictureUrl,
        "senderUsername": sender.username,
        "lastMessage": "",
        "MessageRoomPeople": [sender.email, receiver.email],
        "senderCubeId": sender.cubeid,
        "receiverCubeId": receiver.cubeid
      }).then((value) {
        id = value.id;
        return id;
      });
      return id;
    } catch (e) {
      print(e);
      return id;
    }
  }

  static Future<MessageRoom> checkAvaliableMessageRoom(String receiverMail, String senderMail, bool anon) async {
    //THIS FUNCTION CHECKS IF THERE IS A CURRENT MESSAGEROOM
    MessageRoom message = MessageRoom("", [], "", "", "", "", "", "", DateTime.now(), "", true, false, 0, 0);
    await db.collection('messages').where("MessageRoomPeople", arrayContains: senderMail).get().then((value) {
      value.docs.forEach((element) {
        if (element.get('anonim') == anon) {
          if (element.get('senderMail') == receiverMail || element.get('receiverMail') == receiverMail) {
            //print("LLLLL" + element.id);
            message = MessageRoom(
                element.id,
                element.get('MessageRoomPeople'),
                element.get('senderMail'),
                element.get('senderUsername'),
                element.get('senderProfilePictureUrl'),
                element.get('receiverMail'),
                element.get('receiverProfilePictureUrl'),
                element.get('receiverUsername'),
                element.get('lastMessageTime').toDate(),
                element.get('lastMessage'),
                element.get('anonim'),
                element.get('acceptAllMedia'),
                element.get('senderCubeId'),
                element.get('receiverCubeId'));
          }
        }
      });
    });
    return message;
  }

  static Stream<QuerySnapshot> ALLMESSAGES(userMail) {
    // Normal message stream
    List<String> myMessageIdList = [];
    var data = FirebaseFirestore.instance.collection('messages').where("MessageRoomPeople", arrayContains: userMail).snapshots();
    return data;
  }

  static Stream<QuerySnapshot> messages(userMail) {
    // Normal message stream
    var data = FirebaseFirestore.instance
        .collection('messages')
        .where("anonim", isEqualTo: false)
        .where("MessageRoomPeople", arrayContains: userMail)
        .orderBy("lastMessageTime", descending: true)
        .snapshots();
    return data;
  }

  static Stream<QuerySnapshot> ANONmessages(userMail) {
    // anon message stream
    var data = FirebaseFirestore.instance
        .collection('messages')
        .where("anonim", isEqualTo: true)
        .where("MessageRoomPeople", arrayContains: userMail)
        .orderBy("lastMessageTime", descending: true)
        .snapshots();
    return data;
  }

  static Future<bool> addNewUser(id, email, age, chatCount, profilePictureUrl, followers, followed, gender, isActive, lastActiveTime,
      firstName, lastName, likes, userBio, userTags, userType, username, videoServicePassword, cubeid) async {
    //this function will add new user to users collection
    try {
      var result = await db.collection('users').add(User(
              id,
              email,
              age,
              chatCount,
              profilePictureUrl,
              followers,
              followed,
              gender,
              isActive,
              lastActiveTime,
              firstName,
              lastName,
              likes,
              userBio,
              userTags,
              userType,
              username,
              "Türkiye",
              "İstanbul",
              [],
              [],
              [],
              [],
              [],
              true,
              [],
              videoServicePassword,
              cubeid)
          .toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> addSpotifyListItem(String url) async {
    try {
      await FirestoreHelper.getUserData().then((value) {
        db.collection('users').doc(value.id).update({
          'SpotifyList': FieldValue.arrayUnion([url])
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeSpotifyListItem(String url) async {
    try {
      await FirestoreHelper.getUserData().then((value) {
        db.collection('users').doc(value.id).update({
          'SpotifyList': FieldValue.arrayRemove([url])
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addMovieListItem(String url) async {
    try {
      await FirestoreHelper.getUserData().then((value) {
        db.collection('users').doc(value.id).update({
          'MovieList': FieldValue.arrayUnion([url])
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeMovieListItem(String url) async {
    try {
      await FirestoreHelper.getUserData().then((value) {
        db.collection('users').doc(value.id).update({
          'MovieList': FieldValue.arrayRemove([url])
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addHobbieListItem(String url) async {
    try {
      await FirestoreHelper.getUserData().then((value) {
        db.collection('users').doc(value.id).update({
          'hobbies': FieldValue.arrayUnion([url])
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeHobbieListItem(String url) async {
    try {
      await FirestoreHelper.getUserData().then((value) {
        db.collection('users').doc(value.id).update({
          'hobbies': FieldValue.arrayRemove([url])
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addYoutubeListItem(String url) async {
    try {
      await FirestoreHelper.getUserData().then((value) {
        db.collection('users').doc(value.id).update({
          'myYoutubeVideo': FieldValue.arrayUnion([url])
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeYoutubeListItem(String url) async {
    try {
      await FirestoreHelper.getUserData().then((value) {
        db.collection('users').doc(value.id).update({
          'myYoutubeVideo': FieldValue.arrayRemove([url])
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> changeUserActiveStatusAndTime(bool isActive) async {
    try {
      await FirestoreHelper.getUserData().then(
        (value) {
          if (value.id.isNotEmpty) {
            if (isActive == true) {
              if (value != null) {
                if (value.id.isNotEmpty) {
                  db.collection('users').doc(value.id).update({"isActive": isActive});
                }
              }
            } else {
              db.collection('users').doc(value.id).update({"isActive": isActive, "lastActiveTime": DateTime.now()});
            }
          }
        },
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
