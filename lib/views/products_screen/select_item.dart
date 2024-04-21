import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/products_controller.dart';
import 'package:seller_finalproject/controllers/profile_controller.dart';
import 'package:seller_finalproject/views/widgets/our_button.dart';

class SelectItemPage extends StatefulWidget {
  final List<Product> products;
  final Function(Product) onProductSelected;

  SelectItemPage(
      {Key? key, required this.products, required this.onProductSelected})
      : super(key: key);

  @override
  _SelectItemPageState createState() => _SelectItemPageState();
}

class _SelectItemPageState extends State<SelectItemPage> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        // leading: const BackButton(),
        title: const Text('Select Item').text.fontFamily(medium).size(24).make(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                var item = widget.products[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selectedIndex == index ? primaryApp : thinGrey0,
                      width: 2.0,
                    ),
                   
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0),
                    leading: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        color: greyColor,
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: NetworkImage(item.imageUrls.isNotEmpty
                              ? item.imageUrls.first
                              : ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(item.name),
                    subtitle: Text('${item.price} Baht'),
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      widget.onProductSelected(widget.products[index]);
                    },
                  ),
                );
              },
            ),
          ),
          ourButton(
            title: 'Next',
            color: primaryApp,
            textColor: whiteColor,
            
            onPress: () {
              if (selectedIndex != null) {
                var selectedProduct = widget.products[selectedIndex!];
                Get.back(result: selectedProduct.imageUrls);
              } else {
                Get.snackbar('Error', 'No item selected',
                    snackPosition: SnackPosition.BOTTOM);
              }
            },
          )
              .box
              .margin(const EdgeInsets.symmetric(vertical: 28, horizontal: 20))
              .make(),
        ],
      ),
    );
  }
}
