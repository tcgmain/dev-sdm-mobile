// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:sdm_mobile/view/home_view1.dart';
import 'package:sdm_mobile/view/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackButtonPressed;

  const CommonAppBar({
    super.key,
    required this.title,
    required this.onBackButtonPressed, required String userName,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _CommonAppBarState createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  String? username;

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Guest';
    });
  }

  @override
  Widget build(BuildContext context) {
        return ClipRRect(
          // borderRadius: const BorderRadius.only(
          //   //bottomLeft: Radius.circular(10.0), // Adjust the radius for bottom-left corner
          //   //bottomRight: Radius.circular(10.0),  // Adjust the radius for bottom-right corner
          // ),
          child: AppBar(
            toolbarHeight: 50.0,
            foregroundColor: const  Color.fromARGB(255, 6, 235, 243).withOpacity(1),
            backgroundColor: const Color.fromARGB(101, 32, 188, 165),
            title: Text(widget.title),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBackButtonPressed,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage1()),
                        (Route<dynamic> route) => false,
                      ));
                },
              ),
              PopupMenuButton<String>(
                onSelected: (String result) {
                  if (result == 'logout') {
                    WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                          (Route<dynamic> route) => false,
                        ));
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'userName',
                    enabled: false,
                    child: Text(username ?? ''),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ],
              ),
            ],
          ),
        );
      }

}
