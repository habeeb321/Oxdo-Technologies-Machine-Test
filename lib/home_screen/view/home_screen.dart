import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oxdo_technologies/home_screen/controller/home_controller.dart';
import 'package:oxdo_technologies/home_screen/view/widgets/table_widget.dart';
import 'package:oxdo_technologies/home_screen/view/widgets/title_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleWidget(),
                  const SizedBox(height: 20),
                  const TableWidget(),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff07BAFE),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: const Icon(Icons.arrow_back_ios, size: 20),
      centerTitle: false,
      title: const Text(
        'New Material Request',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
