import 'package:flutter/material.dart';
import 'package:oxdo_technologies/home_screen/widgets/title_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWidget(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      leading: const Icon(Icons.arrow_back_ios, size: 20),
      centerTitle: false,
      title: const Text(
        'New Material Request',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
