import 'package:seller_finalproject/views/messages_screen/components/chat_bubble.dart';

import '../../const/const.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( chat),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          Expanded(
              child: ListView.builder(
            itemCount: 20,
            itemBuilder: ((context, index) {
              return chatBubble();
            }),
          )),
          10.heightBox,
          SizedBox(
              height: 56,
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        hintText: "Enter message",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryApp)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryApp))),
                  )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                        color: primaryApp,
                      ))
                ],
              )),
          10.heightBox,
        ]),
      ),
    );
  }
}
