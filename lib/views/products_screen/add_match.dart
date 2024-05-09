import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/match_controller.dart';
import 'package:seller_finalproject/controllers/profile_controller.dart';
import 'package:seller_finalproject/views/widgets/custom_textfield.dart';

class AddMatchProduct extends StatefulWidget {
  @override
  _AddMatchProductState createState() => _AddMatchProductState();
}

class _AddMatchProductState extends State<AddMatchProduct> {
  final PageController _topController = PageController(viewportFraction: 0.6);
  final PageController _bottomController =
      PageController(viewportFraction: 0.6);
  final MatchController controller = Get.put(MatchController());

  int _currentTopIndex = 0;
  int _currentLowerIndex = 0;

  @override
  void initState() {
    super.initState();
    _topController.addListener(() {
      int nextIndex = _topController.page!.round();
      if (_currentTopIndex != nextIndex) {
        _currentTopIndex = nextIndex;
      }
    });

    _bottomController.addListener(() {
      int nextIndex = _bottomController.page!.round();
      if (_currentLowerIndex != nextIndex) {
        _currentLowerIndex = nextIndex;
      }
    });
  }

  @override
  void dispose() {
    _topController.dispose();
    _bottomController.dispose();
    controller.resetController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Product'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              onSaveButtonPressed(context);
            },
            child: const Text('Save', style: TextStyle(color: primaryApp)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 110,
              child: buildTopPageView(_topController, controller),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 110,
              child: buildLowerPageView(_bottomController, controller),
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
                    controller: controller.psizeController)
                .box
                .padding(EdgeInsetsDirectional.all(12))
                .make(),
            const SizedBox(height: 20),
            buildColorChoices(controller),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: greyDark1,
          fontFamily: medium,
        ),
      ),
    );
  }

  Widget buildGenderChips(MatchController controller) {
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
              spacing: 8,
              runSpacing: 8,
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

  Widget buildCollectionChips(MatchController controller) {
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
              spacing: 8,
              runSpacing: 8,
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

  Widget buildColorChoices(MatchController controller) {
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
            spacing: 10,
            runSpacing: 10,
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

  Widget buildTopPageView(
      PageController controller, MatchController matchController) {
    return FutureBuilder<Rxn<List<Product>>>(
      future: matchController.fetchTopProductsByVendor(currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data?.value != null &&
            snapshot.data!.value!.isNotEmpty) {
          return buildPageView(controller, snapshot.data!.value!,
              matchController.onTopProductSelected);
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }

  Widget buildLowerPageView(
      PageController controller, MatchController matchController) {
    return FutureBuilder<Rxn<List<Product>>>(
      future: matchController.fetchLowerProductsByVendor(currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data?.value != null &&
            snapshot.data!.value!.isNotEmpty) {
          return buildPageView(controller, snapshot.data!.value!,
              matchController.onLowerProductSelected);
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }

  Widget buildPageView(PageController controller, List<Product> products,
      Function(Product) onSelectProduct) {
    return PageView.builder(
      controller: controller,
      itemCount: products.length,
      onPageChanged: (index) {
        if (controller == _topController) {
          _currentTopIndex = index;
        } else if (controller == _bottomController) {
          _currentLowerIndex = index;
        }
        onSelectProduct(products[index]);
      },
      itemBuilder: (context, index) {
        Product product = products[index];
        double scale = 1;
        if (controller.position.haveDimensions) {
          double pageOffset = controller.page! - index;
          scale = (1 - (pageOffset.abs() * 0.2)).clamp(0.8, 1);
        }

        final double baseSize = 90;
        final double height = Curves.easeInOut.transform(scale) * baseSize;
        final double width = Curves.easeInOut.transform(scale) * baseSize;

        return Center(
          child: SizedBox(
            height: height,
            width: width,
            child: Image.network(
              product.imageUrls[0],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      physics: const BouncingScrollPhysics(),
    );
  }

  Future<void> onSaveButtonPressed(BuildContext context) async {
    try {
      final topProducts = await controller
          .fetchTopProductsByVendor(currentUser!.uid)
          .then((rxn) => rxn.value!);
      final lowerProducts = await controller
          .fetchLowerProductsByVendor(currentUser!.uid)
          .then((rxn) => rxn.value!);

      if (topProducts.isNotEmpty && lowerProducts.isNotEmpty) {
        Product topProduct = topProducts[_currentTopIndex];
        Product lowerProduct = lowerProducts[_currentLowerIndex];

        if (topProduct != null && lowerProduct != null) {
          String mixMatchValue = controller.generateRandomString(10);

          await controller.updateProductMatch(
              context, topProduct.id, mixMatchValue);
          await controller.updateProductMatch(
              context, lowerProduct.id, mixMatchValue);

          print('Success: Products updated with MixMatch ID $mixMatchValue');
          VxToast.show(context, msg: "Products updated successfully.");
        }
      } else {
        VxToast.show(context, msg: "No products available to save.");
      }
    } catch (e) {
      VxToast.show(context, msg: "Error saving products: ${e.toString()}");
      print("Error saving products: $e");
    }
  }
}
