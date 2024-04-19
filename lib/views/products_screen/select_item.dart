import 'package:flutter/material.dart';
import 'package:seller_finalproject/const/colors.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/views/widgets/our_button.dart';


class SelectItemApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SelectItemPage(),
    );
  }
}

class SelectItemPage extends StatefulWidget {
  @override
  _SelectItemPageState createState() => _SelectItemPageState();
}

class _SelectItemPageState extends State<SelectItemPage> {
  int? _selectedIndex;

  final List<Map<String, dynamic>> _items = [
    // Replace these entries with your actual data
    {'name': 'Item 1', 'price': '100.00 Baht', 'image': 'URL1'},
    {'name': 'Item 2', 'price': '200.00 Baht', 'image': 'URL2'},
    {'name': 'Item 1', 'price': '100.00 Baht', 'image': 'URL3'},
    {'name': 'Item 2', 'price': '200.00 Baht', 'image': 'URL4'},
    {'name': 'Item 1', 'price': '100.00 Baht', 'image': 'URL5'},
    {'name': 'Item 2', 'price': '500000.00 Baht', 'image': 'URL6'},
    // Add other items here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Select Item'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return Card(
                  color: _selectedIndex == index
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : Color.fromARGB(255, 255, 255, 255),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 16.0), // Adjust padding as needed
                    leading: Container(
                      width: 120, // Set your desired width
                      height: 200, // Set your desired height, adjust as needed
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Placeholder color
                        borderRadius: BorderRadius.circular(
                            5), // Optional: if you want rounded corners
                      ),
                      child: Icon(
                        Icons.image, // Placeholder icon
                        color: Colors.grey[500],
                      ),
                    ),
                    title: Text(_items[index]['name']),
                    subtitle: Text(_items[index]['price']),
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          ourButton(
              title: 'Confirm this item to matching',
              color: primaryApp,
              textColor: whiteColor,
              onPress: () {
                
              },
            ).box.margin(EdgeInsets.symmetric(vertical: 28, horizontal: 20)).make(),
        ],
      ),
    );
  }
}
