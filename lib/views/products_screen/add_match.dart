import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/match_controller.dart';

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
    controller.explainController.clear();
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
        title:
            const Text('Match Product').text.size(24).fontFamily(medium).make(),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              String productNameTop = controller.selectedTopProduct?.name ?? '';
              String productNameLower =
                  controller.selectedLowerProduct?.name ?? '';
              String selectedGender = controller.selectedGender.value;
              List<String> selectedCollections = controller.selectedCollections;
              String explanation = controller.explainController.text;

              await onSaveButtonPressed(
                productNameTop,
                productNameLower,
                context,
                selectedGender,
                selectedCollections,
                explanation,
              );
            },
            child: const Text('Save',
                style: TextStyle(
                    color: primaryApp, fontSize: 14, fontFamily: medium)),
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
                  return const Center(child: CircularProgressIndicator());
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
                        controller
                            .onTopProductSelected(snapshot.data!.value![index]);
                      },
                      itemBuilder: (context, index) {
                        Product product = snapshot.data!.value![index];
                        return Center(
                          child: Image.network(
                            product.imageUrls[0],
                            fit: BoxFit.cover,
                          ).box.roundedSM.clip(Clip.antiAlias).make(),
                        )
                            .box
                            .white
                            .margin(const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2))
                            .make();
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
            const SizedBox(height: 5),
            FutureBuilder<Rxn<List<Product>>>(
              future: controller.fetchLowerProductsByVendor(currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                        controller.onLowerProductSelected(
                            snapshot.data!.value![index]);
                      },
                      itemBuilder: (context, index) {
                        Product product = snapshot.data!.value![index];
                        return Center(
                          child: Image.network(
                            product.imageUrls[0],
                            fit: BoxFit.cover,
                          ).box.roundedSM.clip(Clip.antiAlias).make(),
                        )
                            .box
                            .white
                            .margin(const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2))
                            .make();
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
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
                            bool isSelected =
                                controller.selectedGender.value == gender;
                            return Container(
                              width: 105,
                              child: ChoiceChip(
                                showCheckmark: false,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    capitalize(gender),
                                    style: TextStyle(
                                      color:
                                          isSelected ? primaryApp : greyColor,
                                      fontFamily:
                                          isSelected ? semiBold : regular,
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
                                    ? const BorderSide(
                                        color: primaryApp, width: 2)
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
                          spacing: 6,
                          runSpacing: 1,
                          children: controller.collectionList.map((collection) {
                            bool isSelected =
                                controller.isCollectionSelected(collection);
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
                                  ? const BorderSide(
                                      color: primaryApp, width: 2)
                                  : const BorderSide(
                                      color: greyLine, width: 1.3),
                            );
                          }).toList(),
                        )),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Explain clothing matching",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: medium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller.explainController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Enter your explanation here',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(240, 240, 240, 1),
                          ),
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontFamily: regular,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> onSaveButtonPressed(
    String productNameTop,
    String productNameLower,
    BuildContext context,
    String selectedGender,
    List<String> selectedCollections,
    String explanation,
  ) async {
    List<String> productNames = [productNameTop, productNameLower];
    String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (currentUserUID.isEmpty) {
      VxToast.show(context, msg: "User is not logged in.");
      print('Error: User is not logged in.');
      return;
    }

    try {
      print('Fetching user document...');
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(vendorsCollection)
          .doc(currentUserUID)
          .get();

      if (!userDoc.exists) {
        VxToast.show(context, msg: "User not found.");
        print('User not found.');
        return;
      }

      String userName = userDoc['name'] ?? '';
      String userImg = userDoc['imageUrl'] ?? '';

      print('Fetching products...');
      QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection(productsCollection)
          .where('name', whereIn: productNames)
          .get();

      if (productSnapshot.docs.isEmpty) {
        VxToast.show(context, msg: "No products found.");
        print('No products found matching the names.');
        return;
      }

      String productIdTop = '';
      String productIdLower = '';
      for (var doc in productSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          if (doc['name'] == productNameTop) {
            productIdTop = doc.id;
          } else if (doc['name'] == productNameLower) {
            productIdLower = doc.id;
          }
        }
      }

      if (productIdTop.isEmpty || productIdLower.isEmpty) {
        VxToast.show(context, msg: "Failed to retrieve product IDs.");
        print('Failed to retrieve product IDs.');
        return;
      }

      print('Checking for duplicate matches...');
      QuerySnapshot duplicateCheckSnapshot = await FirebaseFirestore.instance
          .collection('storemixandmatchs')
          .where('product_id_top', isEqualTo: productIdTop)
          .where('product_id_lower', isEqualTo: productIdLower)
          .where('vendor_id', isEqualTo: currentUserUID)
          .get();

      if (duplicateCheckSnapshot.docs.isNotEmpty) {
        VxToast.show(context, msg: "This match already exists.");
        print('Duplicate match found.');
        return;
      }

      Map<String, dynamic> userData = {
        'collection': selectedCollections,
        'gender': selectedGender,
        'description': explanation,
        'vendor_id': currentUserUID,
        'favorite_userid': FieldValue.arrayUnion([]),
        'created_at': Timestamp.now(),
        'product_id_top': productIdTop,
        'product_id_lower': productIdLower,
        'views': 0,
        'favorite_count': 0,
      };

      print('Adding data to storemixandmatchs collection...');
      DocumentReference documentReference = await FirebaseFirestore.instance
          .collection('storemixandmatchs')
          .add(userData);

      VxToast.show(context, msg: "Added post successful.");
      print(
          'Data added in storemixandmatchs collection with document ID: ${documentReference.id}');

      controller.resetController();

      if (mounted) {
        print('Navigating back...');
        Navigator.pop(context);
      }
    } catch (error) {
      print('Error: $error');
      if (mounted) {
        VxToast.show(context, msg: "Error: $error");
      }
    }
  }
}
