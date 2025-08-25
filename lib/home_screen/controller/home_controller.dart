import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  RxList<Map<String, dynamic>> materialRequestRows =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredProducts = <Map<String, dynamic>>[].obs;
  RxString searchQuery = ''.obs;
  RxBool showSuggestions = false.obs;
  RxInt currentSearchIndex = (-1).obs;

  List<Map<String, dynamic>> products = [
    {
      "id": 1,
      "title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
      "price": 109.95,
      "description":
          "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
      "category": "men's clothing",
      "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.png",
      "rating": {"rate": 3.9, "count": 120}
    },
    {
      "id": 2,
      "title": "Mens Casual Premium Slim Fit T-Shirts ",
      "price": 22.3,
      "description":
          "Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing. And Solid stitched shirts with round neck made for durability and a great fit for casual fashion wear and diehard baseball fans. The Henley style round neckline includes a three-button placket.",
      "category": "men's clothing",
      "image":
          "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.png",
      "rating": {"rate": 4.1, "count": 259}
    },
  ];

  @override
  void onInit() {
    super.onInit();
    addNewRow();
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
              product['title']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              product['category']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
      showSuggestions.value = filteredProducts.isNotEmpty;
    }
  }

  void selectProduct(Map<String, dynamic> product, int index) {
    materialRequestRows[index]['itemNameController'].text = product['title'];
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
