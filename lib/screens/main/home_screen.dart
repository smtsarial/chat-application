import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/connections/local_notification_api.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/providers/MessageRoomProvider.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/chat/chatScreenTab.dart';
import 'package:anonmy/screens/main/profile_screen.dart';
import 'package:anonmy/screens/main/purchase_screen.dart';
import 'package:anonmy/screens/main/shuffle_screen.dart';
import 'package:anonmy/screens/main/story_screen.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static Route get route => MaterialPageRoute(
        builder: (context) => HomeScreen(),
      );
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> pageIndex = ValueNotifier(0);

  final ValueNotifier<String> title = ValueNotifier('Messages');

  final pages = [
    StoryPage(),
    TabBarChat(),
    ShufflePage(),
    PurchaseScreen(),
    ProfileScreen(),
  ];

  final PremiumPages = [
    StoryPage(),
    TabBarChat(),
    ShufflePage(),
    ProfileScreen(),
  ];

  void _onNavigationItemSelected(index) {
    pageIndex.value = index;
  }

  User user = emptyUser;

  @override
  void initState() {
    super.initState();

    FirestoreHelper.getUserData().then((value) {
      setState(() {
        user = value;
      });
    });
    FirestoreHelper.setUserPurchaseActiveStatus().then((value) async {
      await FirestoreHelper.updateMyPurchaseStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context);
    Provider.of<MessageRoomProvider>(context);
    return SafeArea(
        child: user.userType == "basic"
            ? Scaffold(
                body: ValueListenableBuilder(
                  valueListenable: pageIndex,
                  builder: (BuildContext context, int value, _) {
                    return pages[value];
                  },
                ),
                bottomNavigationBar: _BottomNavigationBar(
                  onItemSelected: _onNavigationItemSelected,
                ),
              )
            : (Scaffold(
                body: ValueListenableBuilder(
                  valueListenable: pageIndex,
                  builder: (BuildContext context, int value, _) {
                    return PremiumPages[value];
                  },
                ),
                bottomNavigationBar: _PremiumBottomNavigatorBar(
                  onItemSelected: _onNavigationItemSelected,
                ),
              )));
  }
}

class _PremiumBottomNavigatorBar extends StatefulWidget {
  const _PremiumBottomNavigatorBar({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);

  final ValueChanged<int> onItemSelected;
  @override
  State<_PremiumBottomNavigatorBar> createState() =>
      __PremiumBottomNavigatorBarState();
}

class __PremiumBottomNavigatorBarState
    extends State<_PremiumBottomNavigatorBar> {
  var selectedIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  void handleItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Card(
      color: (brightness == Brightness.light) ? Colors.transparent : null,
      elevation: 0,
      margin: const EdgeInsets.all(0),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavigationBarItem(
                index: 0,
                label: '',
                icon: CupertinoIcons.bell_solid,
                isSelected: (selectedIndex == 0),
                onTap: handleItemSelected,
              ),
              _NavigationBarItem(
                index: 1,
                label: '',
                icon: CupertinoIcons.bubble_left_bubble_right_fill,
                isSelected: (selectedIndex == 1),
                onTap: handleItemSelected,
              ),
              _NavigationBarItem(
                index: 2,
                label: '',
                icon: CupertinoIcons.shuffle,
                isSelected: (selectedIndex == 2),
                onTap: handleItemSelected,
              ),
              _NavigationBarItem(
                index: 3,
                label: '',
                icon: CupertinoIcons.person,
                isSelected: (selectedIndex == 3),
                onTap: handleItemSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavigationBar extends StatefulWidget {
  const _BottomNavigationBar({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);

  final ValueChanged<int> onItemSelected;

  @override
  __BottomNavigationBarState createState() => __BottomNavigationBarState();
}

class __BottomNavigationBarState extends State<_BottomNavigationBar> {
  var selectedIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  void handleItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Card(
      color: (brightness == Brightness.light) ? Colors.transparent : null,
      elevation: 0,
      margin: const EdgeInsets.all(0),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavigationBarItem(
                index: 0,
                label: '',
                icon: CupertinoIcons.bell_solid,
                isSelected: (selectedIndex == 0),
                onTap: handleItemSelected,
              ),
              _NavigationBarItem(
                index: 1,
                label: '',
                icon: CupertinoIcons.bubble_left_bubble_right_fill,
                isSelected: (selectedIndex == 1),
                onTap: handleItemSelected,
              ),
              _NavigationBarItem(
                index: 2,
                label: '',
                icon: CupertinoIcons.shuffle,
                isSelected: (selectedIndex == 2),
                onTap: handleItemSelected,
              ),
              _NavigationBarItem(
                index: 3,
                label: '',
                icon: CupertinoIcons.rocket,
                isSelected: (selectedIndex == 3),
                onTap: handleItemSelected,
              ),
              _NavigationBarItem(
                index: 4,
                label: '',
                icon: CupertinoIcons.person,
                isSelected: (selectedIndex == 4),
                onTap: handleItemSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  const _NavigationBarItem({
    Key? key,
    required this.index,
    required this.label,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  final int index;
  final String label;
  final IconData icon;
  final bool isSelected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(index);
      },
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? AppColors.secondary : null,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              label,
              style: isSelected
                  ? const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    )
                  : const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
