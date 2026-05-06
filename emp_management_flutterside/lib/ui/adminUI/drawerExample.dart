import 'package:flutter/material.dart';

class DrawerEx extends StatelessWidget {
  const DrawerEx({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text(
              "Hello Bangladesh",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              "helloBangladesh@gmail.com",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBSmhvi6o9QLkZAO9jS3_V_z9QFhAyFepxqA&s",
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: const Text("Page 1"),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("page 1 loaded successfully..!"),
                  duration: Duration(seconds: 1), // optional
                  backgroundColor: Colors.blue, // optional
                  // action: SnackBarAction(
                  //   // optional
                  //   label: "Undo",
                  //   onPressed: () {
                  //     // undo code here
                  //   },
                  // ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: const Text("Page 2"),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text("Page 2 loaded successfully.")),
              );
            },
          ),
        ],
      ),
    );
  }
}
