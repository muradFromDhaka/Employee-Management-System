import 'package:flutter/material.dart';

class CommonAdminDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onLogout;
  final bool isDarkMode;
  final String? userName;
  final String? userEmail;

  const CommonAdminDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onLogout,
    required this.isDarkMode,
    this.userName,
    this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    final items = const [
      {'icon': Icons.people, 'title': 'Employees'},
      {'icon': Icons.apartment, 'title': 'Departments'},
      {'icon': Icons.payments, 'title': 'Payroll'},
      {'icon': Icons.admin_panel_settings, 'title': 'Roles'},
    ];

    return Drawer(
      child: Column(
        children: [
          _buildHeader(),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final selected = selectedIndex == index;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: selected ? Colors.blue.withOpacity(0.15) : null,
                  ),
                  child: ListTile(
                    leading: Icon(
                      item['icon'] as IconData,
                      color: selected ? Colors.blue : Colors.grey,
                    ),
                    title: Text(
                      item['title'] as String,
                      style: TextStyle(
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.normal,
                        color: selected ? Colors.blue : Colors.black87,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onItemSelected(index);
                    },
                  ),
                );
              },
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title:
                const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: onLogout,
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.indigo],
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.admin_panel_settings,
                size: 30, color: Colors.blue),
          ),
          const SizedBox(height: 10),
          Text(
            userName ?? "Admin",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            userEmail ?? "",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}


// =======================CommonAdminAppBar===========================
class CommonAdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CommonAdminAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 161, 223, 231),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}