import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/match_controller.dart';
import 'package:seller_finalproject/controllers/profile_controller.dart';
import 'package:seller_finalproject/views/widgets/custom_textfield.dart';
import 'package:seller_finalproject/views/widgets/edit_textfield.dart';

class EditMatchProduct extends StatefulWidget {
  final Map<String, dynamic> product1;
  final Map<String, dynamic> product2;
  const EditMatchProduct({Key? key, required this.product1, required this.product2}) : super(key: key);

  @override
  _EditMatchProductState createState() => _EditMatchProductState();
}

class _EditMatchProductState extends State<EditMatchProduct> {
  final PageController _topController = PageController(viewportFraction: 0.6);
  final PageController _bottomController = PageController(viewportFraction: 0.6);
  final MatchController controller = Get.put(MatchController());
  late Map<String, dynamic> product1;
  late Map<String, dynamic> product2;

  int _currentTopIndex = 0;
  int _currentLowerIndex = 0;

  int totalTopProductsIndex = products.length;
  int totalLowerProductsIndex = products.length;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      product1 = widget.product1;
      product2 = widget.product2;
    
    List<int> preselectedIndices = [];
    controller.selectedColorIndexes.addAll(preselectedIndices);
    });

_topController.addListener(() {
  int nextIndex = _topController.page!.round();
  if (_currentTopIndex != nextIndex) {
      _currentTopIndex = nextIndex;
      print("Top Page Index Updated: $_currentTopIndex");
  }
});

_bottomController.addListener(() {
  int nextIndex = _bottomController.page!.round();
  if (_currentLowerIndex != nextIndex) {
    _currentLowerIndex = nextIndex;
    print("Bottom Page Index Updated: $_currentLowerIndex");
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
    product1 = widget.product1;
    product2 = widget.product2;
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

    controller.selectedGender.value = widget.product1['p_mixmatch_sex'] ?? '';
    controller.psizeController.text = widget.product1['p_mixmatch_desc'] ?? '';

    if (widget.product1['p_mixmatch_collection'] is List) {
        List<String> collections = List<String>.from(widget.product1['p_mixmatch_collection'].map((item) => item.toString()));
        controller.selectedCollection.assignAll(collections);
    } else {
        controller.selectedCollection.clear();
    }


  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        controller.resetController();
        Navigator.of(context).pop();
      },
    ),
      title: const Text('Edit Match'),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          controller.onSaveButtonPressed(context);
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
              controller: controller.psizeController).box.padding(EdgeInsetsDirectional.all(12)).make(),
          const SizedBox(height: 20),
          buildColorChoices(controller),
        ],
      ),
    ),
  );
}

Widget buildHeader(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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

Widget buildCollectionChips(MatchController controller) {
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
          bool isSelected = controller.selectedCollection.contains(collection);
          return ChoiceChip(
            label: Text(
              capitalize(collection),
              style: TextStyle(
                color: isSelected ? primaryApp : greyDark1,
              ),
            ).text.size(14).fontFamily(regular).make(),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                if (!controller.selectedCollection.contains(collection)) {
                  controller.selectedCollection.add(collection);
                }
              } else {
                controller.selectedCollection.remove(collection);
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
      Obx(() => Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: List.generate(
          controller.allColors.length,
          (index) {
            var colorInfo = controller.allColors[index];
            bool isSelected = controller.selectedColorIndexes.contains(index);
            return GestureDetector(
              onTap: () {
                if (isSelected) {
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
                  color: colorInfo['color'],
                  border: Border.all(
                    color: isSelected ? primaryApp : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : const SizedBox(),
                ),
              ),
            );
          },
        ),
      )),
    ],
  );
}

Widget buildTopPageView(PageController controller, MatchController matchController) {
  return FutureBuilder<Rxn<List<Product>>>(
    future: matchController.fetchTopProductsByVendor(currentUser!.uid),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.data?.value != null && snapshot.data!.value!.isNotEmpty) {
        List<Product> products = snapshot.data!.value!;
        int initialIndex = products.indexWhere((product) => product.mixmatch == widget.product1['p_mixmatch']);

        if (initialIndex != -1 && initialIndex != _currentTopIndex) {
          Product matchingProduct = products.removeAt(initialIndex);
          products.insert(0, matchingProduct);
          _currentTopIndex = 0;
          if (controller.hasClients) {
            controller.jumpToPage(0);
          }
        }

        return buildPageView(controller, products, matchController.onTopProductSelected, products.length, _currentTopIndex);
      } else {
        return const Center(child: Text('No data available'));
      }
    },
  );
}

Widget buildLowerPageView(PageController controller, MatchController matchController) {
  return FutureBuilder<Rxn<List<Product>>>(
    future: matchController.fetchLowerProductsByVendor(currentUser!.uid),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.data?.value != null && snapshot.data!.value!.isNotEmpty) {
        List<Product> products = snapshot.data!.value!;
        int initialIndex = products.indexWhere((product) => product.mixmatch == widget.product2['p_mixmatch']);

        if (initialIndex != -1) {
          Product matchingProduct = products.removeAt(initialIndex);
          products.insert(0, matchingProduct);
          _currentLowerIndex = 0;
          if (controller.hasClients) {
            controller.jumpToPage(0);
          }
        }

        return buildPageView(controller, products, matchController.onLowerProductSelected, products.length, initialIndex);
      } else {
        return const Center(child: Text('No data available'));
      }
    },
  );
}

Widget buildPageView(PageController controller, List<Product> products, Function(Product) onSelectProduct, int totalProductsIndex, int initialIndex) {
  return PageView.builder(
    controller: controller,
    itemCount: totalProductsIndex,
    onPageChanged: (index) {
      if (controller == _topController) {
        totalTopProductsIndex = index;
      } else if (controller == _bottomController) {
        totalLowerProductsIndex = index;
      }
      onSelectProduct(products[index]);
    },
    itemBuilder: (context, index) {
      Product product = products[index];
      double scale = 1.0;
      if (controller.position.haveDimensions) {
        double pageOffset = controller.page! - index;
        scale = (1 - (pageOffset.abs() * 0.2)).clamp(0.8, 1.0);
      }

      final double baseSize = 90.0;
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
}  


