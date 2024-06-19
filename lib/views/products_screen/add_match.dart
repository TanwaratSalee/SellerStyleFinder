import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/match_controller.dart';
import 'package:seller_finalproject/views/products_screen/products_screen.dart';
import 'package:get/get.dart';

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
            onPressed: () async {
              // Retrieve necessary parameters
              String productNameTop = controller.selectedTopProduct?.name ?? '';
              String productNameLower = controller.selectedLowerProduct?.name ?? '';
              String selectedGender = controller.selectedGender.value;
              List<String> selectedCollections = controller.selectedCollections;
              String explanation = controller.explainController.text;

              // Call the onSaveButtonPressed method
              await onSaveButtonPressed(
                productNameTop,
                productNameLower,
                context,
                selectedGender,
                selectedCollections,
                explanation,
              );

              Get.to(() => ProductsScreen());
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
                } else if (snapshot.data?.value != null && snapshot.data!.value!.isNotEmpty) {
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
                        ).box.white.margin(EdgeInsets.symmetric(horizontal: 6, vertical: 2)).make();
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
                } else if (snapshot.data?.value != null && snapshot.data!.value!.isNotEmpty) {
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
                        ).box.white.margin(EdgeInsets.symmetric(horizontal: 6, vertical: 2)).make();
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
                          spacing: 6,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Explain clothing matching",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: medium,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: controller.explainController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Enter your explanation here',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(240, 240, 240, 1),
                          ),
                          style: TextStyle(
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
    String explanation) async {
    List<String> productNames = [productNameTop, productNameLower];
    String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (currentUserUID.isEmpty) {
      VxToast.show(context, msg: "User is not logged in.");
      print('Error: User is not logged in.');
      return;
    }

    // Retrieve user details
    FirebaseFirestore.instance
        .collection(vendorsCollection)
        .doc(currentUserUID)
        .get()
        .then((DocumentSnapshot userDoc) {
      if (userDoc.exists) {
        String userName = userDoc['vendor_name'] ?? '';
        String userImg = userDoc['imageUrl'] ?? '';

        // Log user details for debugging
        print('User Name: $userName');
        print('User Image: $userImg');

        // Retrieve product details
        FirebaseFirestore.instance
            .collection(productsCollection)
            .where('p_name', whereIn: productNames)
            .get()
            .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            Map<String, dynamic> userData = {
              'p_collection': selectedCollections,
              'gender': selectedGender,
              'p_desc': explanation,
              'posted_by': currentUserUID,
            };

            querySnapshot.docs.forEach((doc) {
              var data = doc.data() as Map<String, dynamic>?;
              var wishlist = (data?['favorite'] as List<dynamic>?) ?? [];

              if (!wishlist.contains(currentUserUID)) {
                userData['views'] = 0;
                userData['favorite'] = 0;
                if (doc['p_name'] == productNameTop) {
                  userData['p_id_top'] = doc.id;
                } else if (doc['p_name'] == productNameLower) {
                  userData['p_id_lower'] = doc.id;
                }
              }
            });

            if (userData.keys.length > 1) {
              // Check if any product info was added
              FirebaseFirestore.instance
                  .collection('storemixandmatchs')
                  .add(userData)
                  .then((documentReference) {
                VxToast.show(context, msg: "Added post successful.");
                print(
                    'Data added in storemixandmatchs collection with document ID: ${documentReference.id}');
                
                // Clear the fields
                controller.resetController();
                
                // Navigate back to the previous screen
                Navigator.pop(context);
              }).catchError((error) {
                print('Error adding data in storemixandmatchs collection: $error');
                VxToast.show(context, msg: "Error post.");
              });
            } else {
              VxToast.show(context, msg: "Products already in wishlist.");
            }
          } else {
            print('No products found matching the names.');
            VxToast.show(context, msg: "No products found.");
          }
        }).catchError((error) {
          print('Error retrieving products: $error');
          VxToast.show(context, msg: "Error retrieving products.");
        });
      } else {
        print('User not found.');
        VxToast.show(context, msg: "User not found.");
      }
    }).catchError((error) {
      print('Error retrieving user: $error');
      VxToast.show(context, msg: "Error retrieving user.");
    });
  }
}
