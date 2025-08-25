import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oxdo_technologies/home_screen/controller/home_controller.dart';
import 'package:oxdo_technologies/home_screen/widgets/table_widget.dart';
import 'package:oxdo_technologies/home_screen/widgets/title_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWidget(),
            const SizedBox(height: 20),
            TableWidget(),
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
