import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HobbiesWidget extends StatefulWidget {
  const HobbiesWidget({Key? key, required this.userData}) : super(key: key);
  final User userData;
  @override
  State<HobbiesWidget> createState() => _HobbiesWidgetState();
}

class _HobbiesWidgetState extends State<HobbiesWidget> {
  bool isLoading = true;
  List hobbies = [];
  @override
  void initState() {
    if (mounted) {
      setState(() {
        hobbies = widget.userData.hobbies;
        isLoading = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 0,
        child: SizedBox(
          height: 92,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0, top: 8, bottom: 16),
                child: Text(
                  "Hobbies List",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: AppColors.textFaded,
                  ),
                ),
              ),
              isLoading
                  ? (Center(
                      child: Shimmer.fromColors(
                        baseColor: Colors.deepPurple,
                        highlightColor: Colors.white,
                        child: Image.asset(
                          "assets/images/seffaf_renkli.png",
                          height: 50,
                        ),
                      ),
                    ))
                  : hobbies.length != 0
                      ? (Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: hobbies.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(2, 1, 8, 2),
                                child: SizedBox(
                                  child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        decoration: BoxDecoration(
                                            color: PrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Center(
                                          child: Text(hobbies[index]),
                                        ),
                                      )),
                                ),
                              );
                            },
                          ),
                        ))
                      : (Container(
                          child: Center(
                            child: Text(
                              "There is no hobbies.",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                color: AppColors.textFaded,
                              ),
                            ),
                          ),
                        ))
            ],
          ),
        ),
      ),
    );
  }
}
