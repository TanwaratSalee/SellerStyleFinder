import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:seller_finalproject/const/colors.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/controllers/products_controller.dart';
import 'package:seller_finalproject/controllers/profile_controller.dart';
import 'package:seller_finalproject/views/widgets/our_button.dart';


class SelectItemPage extends StatefulWidget {
  final List<Product> products;
  final Function(Product) onProductSelected;

  SelectItemPage({Key? key, required this.products, required this.onProductSelected}) : super(key: key);

  @override
  _SelectItemPageState createState() => _SelectItemPageState();
}

class _SelectItemPageState extends State<SelectItemPage> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Select Item'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.products.length, // Modify this line
              itemBuilder: (context, index) {
                var item = widget.products[index]; // Add this line
                return Card(
                  color: _selectedIndex == index ? Colors.lightBlueAccent : Colors.white,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                    leading: Container(
                      width: 80,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: NetworkImage(item.imageUrls.isNotEmpty ? item.imageUrls.first : ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(item.name),
                    subtitle: Text('${item.price} Baht'),
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                        widget.onProductSelected(widget.products[index]);
                      },
                  ),
                );
              },
            ),
          ),
          ourButton(
            title: 'Confirm this item to matching',
            color: primaryApp,
            textColor: whiteColor,
              onPress: () {
                if (_selectedIndex != null) {
                  var selectedProduct = widget.products[_selectedIndex!];
                  Get.back(result: selectedProduct.imageUrls);
                } else {
                  Get.snackbar('Error', 'No item selected', snackPosition: SnackPosition.BOTTOM);
                }
              },
          ).box.margin(EdgeInsets.symmetric(vertical: 28, horizontal: 20)).make(),
        ],
      ),
    );
  }
}
