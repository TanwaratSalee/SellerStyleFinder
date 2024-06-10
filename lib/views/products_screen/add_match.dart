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
  final MatchController controller = Get.put(MatchController());

  int _currentTopIndex = 0;
  int _currentLowerIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.resetController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Product').text.size(24).fontFamily(medium).make(),
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
            FutureBuilder<Rxn<List<Product>>>(
              future: controller.fetchTopProductsByVendor(currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data?.value != null &&
                    snapshot.data!.value!.isNotEmpty) {
                  return SizedBox(
                    width: 390,
                    height: 200,
                    child: VxSwiper.builder(
                      itemCount: snapshot.data!.value!.length,
                      viewportFraction: 0.6,
                      onPageChanged: (index) {
                        _currentTopIndex = index;
                        controller.onTopProductSelected(snapshot.data!.value![index]);
                      },
                      itemBuilder: (context, index) {
                        Product product = snapshot.data!.value![index];
                        return Center(
                          child: Image.network(
                            product.imageUrls[0],
                            fit: BoxFit.cover,
                          ).box.roundedSM.clip(Clip.antiAlias).make(),
                        ).box.white.margin(EdgeInsets.symmetric(horizontal: 6,vertical: 2)).make();
                      },
                      
                    ),
                    
                  );
                  
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ).box.color(greyThin).make(),
            const SizedBox(height: 5),
            FutureBuilder<Rxn<List<Product>>>(
              future: controller.fetchLowerProductsByVendor(currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data?.value != null &&
                    snapshot.data!.value!.isNotEmpty) {
                  return SizedBox(
                    width: 390,
                    height: 200,
                    child: VxSwiper.builder(
                      itemCount: snapshot.data!.value!.length,
                      viewportFraction: 0.6,
                      onPageChanged: (index) {
                        _currentLowerIndex = index;
                        controller.onLowerProductSelected(snapshot.data!.value![index]);
                      },
                      itemBuilder: (context, index) {
                        Product product = snapshot.data!.value![index];
                        return Center(
                          child: Image.network(
                            product.imageUrls[0],
                            fit: BoxFit.cover,
                          ).box.roundedSM.clip(Clip.antiAlias).make(),
                        ).box.white.margin(EdgeInsets.symmetric(horizontal: 6,vertical: 2)).make();
                      },
                    ),
                  );
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ).box.color(greyThin).make(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Suitable for gender")
                  .text
                  .size(16)
                  .color(blackColor)
                  .fontFamily(medium)
                  .make(),
              const SizedBox(height: 8),
              Center(
                child: Obx(() => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.genderList.map((gender) {
                        bool isSelected = controller.selectedGender.value == gender;
                        return Container(
                          width: 105,
                          child: ChoiceChip(
                            showCheckmark: false,
                            label: Container(
                              alignment: Alignment.center,
                              child: Text(
                                capitalize(gender),
                                style: TextStyle(
                                  color: isSelected ? primaryApp : greyColor,
                                  fontFamily: isSelected ? semiBold : regular,
                                ),
                              ).text.size(14).make(),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                controller.selectedGender.value = gender;
                              }
                            },
                            selectedColor: thinPrimaryApp,
                            backgroundColor: whiteColor,
                            side: isSelected
                                ? const BorderSide(color: primaryApp, width: 2)
                                : const BorderSide(color: greyLine),
                          ),
                        );
                      }).toList(),
                    )),
              ),
              const SizedBox(height: 15),
              const Text("Collection")
                  .text
                  .size(16)
                  .color(blackColor)
                  .fontFamily(medium)
                  .make(),
              const SizedBox(height: 8),
              Center(
                child: Obx(() => Wrap(
                      spacing: 8,
                      runSpacing: 1,
                      children: controller.collectionList.map((collection) {
                        bool isSelected = controller.isCollectionSelected(collection);
                        return ChoiceChip(
                          showCheckmark: false,
                          label: Container(
                            width: 75,
                            alignment: Alignment.center,
                            child: Text(
                              capitalize(collection),
                              style: TextStyle(
                                color: isSelected ? primaryApp : greyColor,
                                fontFamily: isSelected ? semiBold : regular,
                              ),
                            ).text.size(14).make(),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            controller.toggleCollection(collection);
                          },
                          selectedColor: thinPrimaryApp,
                          backgroundColor: whiteColor,
                          side: isSelected
                              ? const BorderSide(color: primaryApp, width: 2)
                              : const BorderSide(color: greyLine, width: 1.3),
                        );
                      }).toList(),
                    )),
              ),
              const SizedBox(height: 15),
              customTextFieldInput(
                      heading: "Explain clothing matching",
                      isDesc: true,
                      controller: controller.psizeController),
              const SizedBox(height: 15),
              const Text("Choose product colors")
                  .text
                  .size(16)
                  .color(blackColor)
                  .fontFamily(medium)
                  .make(),
              const SizedBox(height: 8),
              Center(
                child: Obx(
                  () => Wrap(
                    spacing: 25,
                    runSpacing: 15,
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
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
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
                                        ? blackColor
                                        : whiteColor,
                                  )
                                : const SizedBox(),
                          ),
                        ).box.border(color: greyLine).roundedSM.make(),
                      ),
                    ),
                  ),
                ),
              ),
                ],
              ),
            )
          ],
        ),
      ),
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
