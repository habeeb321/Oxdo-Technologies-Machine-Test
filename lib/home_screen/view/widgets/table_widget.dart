import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:oxdo_technologies/home_screen/controller/home_controller.dart';

class TableWidget extends StatefulWidget {
  const TableWidget({super.key});

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  final HomeController controller = Get.find<HomeController>();

  Map<int, int> selectedSuggestionIndexMap = {};

  FocusNode? currentFocusNode;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.loading.value
          ? const SizedBox(
              height: 200,
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            )
          : Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                        child: Table(
                          border: TableBorder.all(color: Colors.grey.shade300),
                          columnWidths: const {
                            0: FlexColumnWidth(0.8),
                            1: FlexColumnWidth(3.5),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(2.5),
                          },
                          children: [
                            TableRow(
                              children: [
                                _buildHeaderCell('SI No'),
                                _buildHeaderCell('Item Name'),
                                _buildHeaderCell('Qty'),
                                _buildHeaderCell('Remarks'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ...controller.materialRequestRows
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        var row = entry.value;

                        int selectedSuggestionIndex =
                            selectedSuggestionIndexMap[index] ?? 0;

                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: index ==
                                        controller.materialRequestRows.length -
                                            1
                                    ? Colors.transparent
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                          child: Table(
                            border:
                                TableBorder.all(color: Colors.grey.shade300),
                            columnWidths: const {
                              0: FlexColumnWidth(0.8),
                              1: FlexColumnWidth(3.5),
                              2: FlexColumnWidth(1),
                              3: FlexColumnWidth(2.5),
                            },
                            children: [
                              TableRow(
                                children: [
                                  _buildDataCell(Text((index + 1).toString())),
                                  _buildDataCell(
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RawKeyboardListener(
                                          focusNode: FocusNode(),
                                          onKey: (event) {
                                            if (controller
                                                    .showSuggestions.value &&
                                                controller.currentSearchIndex
                                                        .value ==
                                                    index &&
                                                controller.filteredProducts
                                                    .isNotEmpty) {
                                              if (event.isKeyPressed(
                                                  LogicalKeyboardKey
                                                      .arrowDown)) {
                                                setState(() {
                                                  selectedSuggestionIndex =
                                                      (selectedSuggestionIndex +
                                                              1) %
                                                          controller
                                                              .filteredProducts
                                                              .length;
                                                  selectedSuggestionIndexMap[
                                                          index] =
                                                      selectedSuggestionIndex;
                                                });
                                              } else if (event.isKeyPressed(
                                                  LogicalKeyboardKey.arrowUp)) {
                                                setState(() {
                                                  selectedSuggestionIndex =
                                                      (selectedSuggestionIndex -
                                                              1 +
                                                              controller
                                                                  .filteredProducts
                                                                  .length) %
                                                          controller
                                                              .filteredProducts
                                                              .length;
                                                  selectedSuggestionIndexMap[
                                                          index] =
                                                      selectedSuggestionIndex;
                                                });
                                              } else if (event.isKeyPressed(
                                                  LogicalKeyboardKey.enter)) {
                                                final product = controller
                                                        .filteredProducts[
                                                    selectedSuggestionIndex];
                                                controller.selectProduct(
                                                    product, index);
                                                setState(() {
                                                  selectedSuggestionIndexMap[
                                                      index] = 0;
                                                });
                                              }
                                            }
                                          },
                                          child: TextField(
                                            controller:
                                                row['itemNameController'],
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 12),
                                              hintText: 'Search items...',
                                            ),
                                            style:
                                                const TextStyle(fontSize: 14),
                                            onChanged: (value) {
                                              controller.updateSearchQuery(
                                                  value, index);
                                              setState(() {
                                                selectedSuggestionIndexMap[
                                                    index] = 0;
                                              });
                                            },
                                            onTap: () {
                                              controller.showSuggestions.value =
                                                  true;
                                              controller.currentSearchIndex
                                                  .value = index;
                                              setState(() {
                                                selectedSuggestionIndexMap[
                                                    index] = 0;
                                              });
                                            },
                                          ),
                                        ),
                                        if (controller.showSuggestions.value &&
                                            controller
                                                .searchQuery.value.isNotEmpty &&
                                            controller
                                                    .currentSearchIndex.value ==
                                                index)
                                          Container(
                                            constraints: const BoxConstraints(
                                                maxHeight: 150),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey.shade300),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 1,
                                                  blurRadius: 3,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: controller
                                                  .filteredProducts.length,
                                              itemBuilder:
                                                  (context, suggestionIndex) {
                                                var product =
                                                    controller.filteredProducts[
                                                        suggestionIndex];
                                                bool isSelected =
                                                    suggestionIndex ==
                                                        selectedSuggestionIndex;
                                                return InkWell(
                                                  onTap: () =>
                                                      controller.selectProduct(
                                                          product, index),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    color: isSelected
                                                        ? Colors.blue.shade100
                                                        : Colors.transparent,
                                                    child: Text(
                                                      product.title ?? '',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: isSelected
                                                            ? Colors.blue
                                                            : Colors.black,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  _buildDataCell(
                                    TextField(
                                      controller: row['qtyController'],
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 12),
                                      ),
                                      style: const TextStyle(fontSize: 14),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  _buildDataCell(
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller:
                                                row['remarksController'],
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 12),
                                            ),
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        if (controller
                                                .materialRequestRows.length >
                                            1)
                                          IconButton(
                                            onPressed: () =>
                                                controller.deleteRow(index),
                                            icon: const Icon(Icons.close,
                                                color: Colors.red, size: 20),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: controller.addNewRow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff14CB74),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 18),
                        SizedBox(width: 5),
                        Text('Add Item',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color.fromARGB(255, 5, 46, 112),
        ),
      ),
    );
  }

  Widget _buildDataCell(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: child,
    );
  }
}
