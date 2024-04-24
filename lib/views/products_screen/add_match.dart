import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/products_controller.dart';
import 'package:seller_finalproject/controllers/profile_controller.dart';
import 'package:seller_finalproject/views/widgets/custom_textfield.dart';

class AddMatchProduct extends StatefulWidget {
  @override
  _AddMatchProductState createState() => _AddMatchProductState();
}

class _AddMatchProductState extends State<AddMatchProduct> {
  final PageController _topController = PageController(viewportFraction: 0.6);
  final PageController _bottomController = PageController(viewportFraction: 0.6);

@override
Widget build(BuildContext context) {
  var controller = Get.find<ProductsController>();
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text('Match Product'),
      actions: <Widget>[
        TextButton(
          onPressed: () {},
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 110, 
            child: buildPageView(_topController),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 110, 
            child: buildPageView(_bottomController),
          ),
          const SizedBox(height: 20),
          buildGenderChips(controller),
          const SizedBox(height: 15),
          buildCollectionChips(controller),
          const SizedBox(height: 15),
          customTextField(
              hint: "Explain clothing matching",
              label: "Explain clothing matching",
              isDesc: true,
              controller: controller.psizeController).box.padding(EdgeInsetsDirectional.all(12)).make(),
          const SizedBox(height: 20),
          buildColorChoices(controller),
        ],
      ),
    ),
  );
}

Widget buildGenderChips(ProductsController controller) {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Suitable for gender")
          .text
          .size(16)
          .color(greyDark1)
          .fontFamily(medium)
          .make(),
      const SizedBox(height: 10),
      Obx(() => Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: controller.genderList.map((gender) {
              bool isSelected = controller.selectedGender.value == gender;
              return ChoiceChip(
                showCheckmark: false,
                label: Text(
                  capitalize(gender),
                  style: TextStyle(
                    color: isSelected ? primaryApp : greyDark1,
                  ),
                ).text.size(18).fontFamily(regular).make(),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    controller.selectedGender.value = gender;
                  }
                },
                selectedColor: thinPrimaryApp,
                backgroundColor: thinGrey0,
                side: isSelected
                    ? const BorderSide(color: primaryApp, width: 2)
                    : const BorderSide(color: greyColor),
              );
            }).toList(),
          )),
    ],
  );
}

Widget buildCollectionChips(ProductsController controller) {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Collection")
          .text
          .size(16)
          .color(greyDark1)
          .fontFamily(medium)
          .make(),
      const SizedBox(height: 10),
      Obx(() => Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: controller.collectionList.map((collection) {
              bool isSelected = controller.isCollectionSelected(collection);
              return ChoiceChip(
                showCheckmark: false,
                label: Text(
                  capitalize(collection),
                  style: TextStyle(
                    color: isSelected ? primaryApp : greyDark1,
                  ),
                ), 
                selected: isSelected,
                onSelected: (selected) {
                  controller.toggleCollection(collection);
                },
                selectedColor: thinPrimaryApp,
                backgroundColor: thinGrey0,
                side: isSelected
                    ? const BorderSide(color: primaryApp, width: 2)
                    : const BorderSide(color: greyColor),
              );
            }).toList(),
          )),
    ],
  );
}

Widget buildColorChoices(ProductsController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Choose product colors")
          .text
          .size(16)
          .color(greyDark1)
          .fontFamily(medium)
          .make(),
      const SizedBox(height: 15),
      Obx(
        () => Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: List.generate(
            controller.allColors.length,
            (index) => GestureDetector(
              onTap: () {
                if (controller.selectedColorIndexes.contains(index)) {
                  controller.selectedColorIndexes.remove(index);
                } else {
                  controller.selectedColorIndexes.add(index);
                }
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: controller.allColors[index]['color'],
                  border: Border.all(
                    color: controller.selectedColorIndexes.contains(index)
                        ? primaryApp
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: controller.selectedColorIndexes.contains(index)
                      ? Icon(
                          Icons.done,
                          color: controller.allColors[index]['color'] ==
                                  whiteColor
                              ? Colors.black
                              : whiteColor,
                        )
                      : const SizedBox(),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildPageView(PageController controller) {
  return PageView.builder(
    controller: controller,
    itemCount: 6, 
    itemBuilder: (context, index) {
      return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          double scale = 1.0;
          if (controller.position.haveDimensions) {
            double pageOffset = controller.page! - index;
            scale = (1 - (pageOffset.abs() * 0.2)).clamp(0.8, 1.2); 
          }

          final double baseSize = 100.0; 
          final double height = Curves.easeInOut.transform(scale) * baseSize;
          final double width = Curves.easeInOut.transform(scale) * baseSize;

          return Center(
            child: SizedBox(
              height: height,
              width: width,
              child: child,
            ),
          );
        },
        child: Image.asset(
          imgProduct,
          fit: BoxFit.cover,
        ),
      );
    },
    physics: const BouncingScrollPhysics(), 
  );
}
}  


