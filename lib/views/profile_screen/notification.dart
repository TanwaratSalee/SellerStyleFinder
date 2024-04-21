import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int notificationCount;

  const NotificationBadge({required this.notificationCount});

  @override
  Widget build(BuildContext context) {
    return notificationCount > 0
        ? Positioned(
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(
                minWidth: 10,
                minHeight: 10,
              ),
              child: Text(
                '$notificationCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : const SizedBox(); // แสดงป้ายกำกับเฉพาะเมื่อมีการแจ้งเตือน
  }
}

// นำเข้า NotificationBadge widget ที่สร้างไว้

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             ListTile(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => EditProfileScreen()),
//                 );
//               },
//               leading: Icon(Icons.edit),
//               title: Text('Edit Profile'),
//             ),
//             ListTile(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ShopSettings()),
//                 );
//               },
//               leading: Stack(
//                 children: [
//                   Icon(Icons.store),
//                   NotificationBadge(
//                       notificationCount: 3), // แสดงป้ายกำกับบนไอคอนของร้านค้า
//                 ],
//               ),
//               title: Text('Shop Settings'),
//             ),
//             ListTile(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => MessagesScreen()),
//                 );
//               },
//               leading: Stack(
//                 children: [
//                   Icon(Icons.message),
//                   NotificationBadge(
//                       notificationCount: 5), // แสดงป้ายกำกับบนไอคอนของข้อความ
//                 ],
//               ),
//               title: Text('Messages'),
//             ),
//             ListTile(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ReviewScreen()),
//                 );
//               },
//               leading: Stack(
//                 children: [
//                   Icon(Icons.star),
//                   NotificationBadge(
//                       notificationCount: 2), // แสดงป้ายกำกับบนไอคอนของรีวิว
//                 ],
//               ),
//               title: Text('Reviews'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
