import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:oxdo_technologies/home_screen/model/get_all_products_model.dart';
import 'package:oxdo_technologies/home_screen/service/home_service.dart';

class HomeController extends GetxController {
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  RxList<Map<String, dynamic>> materialRequestRows =
      <Map<String, dynamic>>[].obs;
  RxList<GetAllProductsModel> filteredProducts = <GetAllProductsModel>[].obs;
  RxString searchQuery = ''.obs;
  RxBool showSuggestions = false.obs;
  RxInt currentSearchIndex = (-1).obs;
  RxList<GetAllProductsModel> products = <GetAllProductsModel>[].obs;
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    addNewRow();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    loading.value = true;
    try {
      List<GetAllProductsModel>? result = await HomeService.getAllProducts();
      if (result != null) {
        products.value = result;
      }
    } catch (e) {
      debugPrint("fetchProducts Error: $e");
    }
    loading.value = false;
  }

  void addNewRow() {
    materialRequestRows.add({
      'itemNameController': TextEditingController(),
      'qtyController': TextEditingController(),
      'remarksController': TextEditingController(),
    });
  }

  void deleteRow(int index) {
    if (materialRequestRows.length > 1) {
      materialRequestRows[index]['itemNameController'].dispose();
      materialRequestRows[index]['qtyController'].dispose();
      materialRequestRows[index]['remarksController'].dispose();
      materialRequestRows.removeAt(index);
    }
    showSuggestions.value = false;
  }

  void updateSearchQuery(String query, int index) {
    searchQuery.value = query;
    currentSearchIndex.value = index;

    if (query.isEmpty) {
      showSuggestions.value = false;
      filteredProducts.clear();
    } else {
      filteredProducts.value = products
          .where((product) =>
              product.title!.toLowerCase().contains(query.toLowerCase()) ||
              product.category
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
      showSuggestions.value = filteredProducts.isNotEmpty;
    }
  }

  void selectProduct(GetAllProductsModel product, int index) {
    materialRequestRows[index]['itemNameController'].text = product.title ?? '';
    showSuggestions.value = false;
    searchQuery.value = '';
    currentSearchIndex.value = -1;
  }

  @override
  void onClose() {
    for (var row in materialRequestRows) {
      row['itemNameController'].dispose();
      row['qtyController'].dispose();
      row['remarksController'].dispose();
    }
    super.onClose();
  }
}
