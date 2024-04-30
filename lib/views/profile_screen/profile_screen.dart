import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/auth_controller.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/controllers/profile_controller.dart';
import 'package:seller_finalproject/services/store_services.dart';
import 'package:seller_finalproject/views/auth_screen/login_screen.dart';
import 'package:seller_finalproject/views/messages_screen/messages_screen.dart';
import 'package:seller_finalproject/views/profile_screen/editProfile_screen.dart';
import 'package:seller_finalproject/views/profile_screen/review_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: StoreServices.getProfile(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator(circleColor: primaryApp);
          } else {
            controller.snapshotData = snapshot.data!.docs[0];
            return ListView(
              children: [
                Center(
                  child: Row(
                    children: [
                      25.widthBox,
                      Container(
                        width: 100,
                        height: 100,
                        child: controller.snapshotData['imageUrl'] == ''
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  imgProfile,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ).box.roundedFull.clip(Clip.antiAlias).make(),
                              )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                  controller.snapshotData['imageUrl'],
                                  width: 100,
                                ).box.roundedFull.clip(Clip.antiAlias).make(),
                            ),
                      ),
                      15.widthBox,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${controller.snapshotData['vendor_name']}")
                                .text
                                .size(16)
                                .fontFamily(medium)
                                .make(),
                            Text("${controller.snapshotData['email']}")
                                .text
                                .size(14)
                                .fontFamily(regular)
                                .make(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                10.heightBox,
                const Divider(color: thinGrey0),
                10.heightBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Account".text.size(16).fontFamily(medium).make(),
                    ListTile(
                      leading: Image.asset(
                        icMe,
                        width: 22,
                      ),
                      title: const Text('Edit Account').text.size(15).make(),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {
                        Get.to(() => EditProfileScreen(
                              username: controller.snapshotData['vendor_name'],
                            ));
                      },
                    ),
                    ListTile(
                      leading: Image.asset(
                        icMessage,
                        width: 22,
                      ),
                      title: const Text('Message').text.size(15).make(),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {
                        Get.to(() => const MessagesScreen());
                      },
                    ),
                    ListTile(
                      leading: Image.asset(
                        icReview,
                        width: 22,
                      ),
                      title: const Text('Review').text.size(15).make(),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {
                        Get.to(() => ReviewScreen());
                      },
                    ),
                  ],
                ).box.padding(const EdgeInsets.all(4)).make(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Actions".text.size(16).fontFamily(medium).make(),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout').text.size(15).make(),
                      onTap: () async {
                        await Get.find<AuthController>().signoutMethod(context);
                        Get.offAll(() => const LoginScreen());
                      },
                    ),
                  ],
                )
              ],
            ).box.padding(const EdgeInsets.all(24)).make();
          }
        },
      ),
    );
  }
}
