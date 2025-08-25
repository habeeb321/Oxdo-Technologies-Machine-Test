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
  RxBool loading = false.obs;

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
      'itemNameFocus': FocusNode(),
      'qtyFocus': FocusNode(),
      'remarksFocus': FocusNode(),
    });
  }

  void deleteRow(int index) {
    if (materialRequestRows.length > 1) {
      materialRequestRows[index]['itemNameController'].dispose();
      materialRequestRows[index]['qtyController'].dispose();
      materialRequestRows[index]['remarksController'].dispose();
      materialRequestRows[index]['itemNameFocus'].dispose();
      materialRequestRows[index]['qtyFocus'].dispose();
      materialRequestRows[index]['remarksFocus'].dispose();
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
      filteredProducts.value = products.where((product) {
        return (product.title?.toLowerCase().contains(query.toLowerCase()) ??
            false);
      }).toList();
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
      row['itemNameFocus'].dispose();
      row['qtyFocus'].dispose();
      row['remarksFocus'].dispose();
    }
    super.onClose();
  }
}
