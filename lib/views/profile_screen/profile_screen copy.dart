import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/controllers/auth_controller.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/controllers/profile_controller.dart';
import 'package:seller_finalproject/services/store_services.dart';
import 'package:seller_finalproject/views/auth_screen/login_screen.dart';
import 'package:seller_finalproject/views/messages_screen/messages_screen.dart';
import 'package:seller_finalproject/views/profile_screen/edit_screen.dart';
import 'package:seller_finalproject/views/profile_screen/notification.dart';
import 'package:seller_finalproject/views/profile_screen/review_screen.dart';

class CopyProfileScreen extends StatefulWidget {
  const CopyProfileScreen({Key? key}) : super(key: key);

  @override
  State<CopyProfileScreen> createState() => _CopyProfileScreenState();
}

class _CopyProfileScreenState extends State<CopyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text( settings),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => EditProfileScreen(
                    username: controller.snapshotData['vendor_name'],
                  ));
            },
            icon: const Icon(Icons.edit),
          ),
          TextButton(
            onPressed: () async {
              await Get.find<AuthController>().signoutMethod(context);
              Get.offAll(() => const LoginScreen());
            },
            child: const Text( logout),
          ),
        ],
      ),
      body: FutureBuilder(
        future: StoreServices.getProfile(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator(circleColor: thinGrey01);
          } else {
            controller.snapshotData = snapshot.data!.docs[0];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    leading: controller.snapshotData['imageUrl'] == ''
                        ? Image.asset(
                            imgProfile,
                            width: 100,
                            fit: BoxFit.cover,
                          ).box.roundedFull.clip(Clip.antiAlias).make()
                        : Image.network(
                            controller.snapshotData['imageUrl'],
                            width: 100,
                          ).box.roundedFull.clip(Clip.antiAlias).make(),
                    title: Text(
                         "${controller.snapshotData['vendor_name']}",
                         ),
                    subtitle: Text(
                         "${controller.snapshotData['email']}",
                         ),
                  ),
                  const Divider(),
                  10.heightBox,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: List.generate(
                        profileButtonsIcons.length,
                        (index) => ListTile(
                          onTap: () {
                            switch (index) {
                              case 0:
                               Get.to(() => EditProfileScreen(
                                username: controller.snapshotData['vendor_name'],));

                                break;
                              case 1:
                                Get.to(() => const MessagesScreen());

                                break;
                              case 2:
                                Get.to(() => ReviewScreen());

                                break;
                              default:
                            }
                          },
                          leading: Stack(
                            children: [
                              Icon(
                                profileButtonsIcons[index],
                                color: greyDark2,
                                size: 2,
                              ),
                              if (index == 1)
                                const NotificationBadge(
                                  notificationCount: 1,
                                ),
                              if (index == 2)
                                const NotificationBadge(
                                  notificationCount: 0,
                                ),
                            ],
                          ),
                          title: Text(
                             profileButtonsTitles[index],
                          ),
                          trailing: Icon(Icons.chevron_right),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
