import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_messenger/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_messenger/common/models/group.dart';
import 'package:whatsapp_messenger/common/models/last_message_model.dart';
import 'package:whatsapp_messenger/common/models/user_model.dart';
import 'package:whatsapp_messenger/common/routes/routes.dart';
import 'package:whatsapp_messenger/common/utils/coloors.dart';
import 'package:whatsapp_messenger/feature/chat/controller/chat_controller.dart';
import 'package:whatsapp_messenger/feature/chat/pages/chat_page.dart';

import '../../../common/widgets/loader.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  const ChatList({
    Key? key,
    required this.recieverUserId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ChatHomePage extends ConsumerWidget {
  const ChatHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<Group>>(
                stream: ref.watch(chatControllerProvider).chatGroups(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var groupData = snapshot.data![index];

                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                ChatPage.routeName,
                                arguments: {
                                  'name': groupData.name,
                                  'uid': groupData.groupId,
                                  'isGroupChat': true,
                                  'profilePic': groupData.groupPic,
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                title: Text(
                                  groupData.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    groupData.lastMessage,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    groupData.groupPic,
                                  ),
                                  radius: 30,
                                ),
                                trailing: Text(
                                  DateFormat.Hm().format(groupData.timeSent),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(color: Coloors.dividerColor, indent: 85),
                        ],
                      );
                    },
                  );
                }),
            StreamBuilder<List<LastMessageModel>>(
              stream: ref.watch(chatControllerProvider).getAllLastMessageList(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Coloors.greenDark,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final lastMessageData = snapshot.data![index];
                    return ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.chat,
                          arguments: UserModel(
                            username: lastMessageData.username,
                            uid: lastMessageData.contactId,
                            profileImageUrl: lastMessageData.profileImageUrl,
                            active: true,
                            lastSeen: 0,
                            phoneNumber: '0',
                            groupId: [],
                          ),
                        );
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(lastMessageData.username),
                          Text(
                            DateFormat.Hm().format(lastMessageData.timeSent),
                            style: TextStyle(
                              fontSize: 13,
                              color: context.theme.greyColor,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          lastMessageData.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: context.theme.greyColor),
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          lastMessageData.profileImageUrl,
                        ),
                        radius: 24,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.contact);
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
