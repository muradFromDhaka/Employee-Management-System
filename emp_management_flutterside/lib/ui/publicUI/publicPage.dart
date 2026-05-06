import 'package:flutter/material.dart';

class PublicPage extends StatefulWidget {
  const PublicPage({super.key});

  @override
  State<PublicPage> createState() => _PublicPageState();
}

class _PublicPageState extends State<PublicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Public Page"),
      ),
      body: const Center(
        child: Text("Welcome to the Employee Management System!"),
      ),
    );
  }
}