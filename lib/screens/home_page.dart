import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removed the appBar property
      drawer: SideMenu(), // Add the side menu here
      body: Column(
        children: [
          // Company Name Container
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Company Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer(); // Open the drawer
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Center(
              child: Text(
                'Home is here!',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Side Menu Widget
class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Option 1'),
            onTap: () {
              // Handle Option 1 tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: Text('Option 2'),
            onTap: () {
              // Handle Option 2 tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              // Handle Logout tap
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}
