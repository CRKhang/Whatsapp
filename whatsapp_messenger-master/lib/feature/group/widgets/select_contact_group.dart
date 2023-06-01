import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_messenger/common/models/user_model.dart';
import 'package:whatsapp_messenger/common/widgets/error.dart';
import 'package:whatsapp_messenger/common/widgets/loader.dart';
import '../../contact/controller/contacts_controller.dart';

final selectedGroupContacts = StateProvider<List<UserModel>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];

  void selectContact(int index, UserModel contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref
        .read(selectedGroupContacts.state)
        .update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(contactsControllerProvider).when(
          data: (contactList) => Expanded(
            child: ListView.builder(
                itemCount: contactList[0].length,
                itemBuilder: (context, index) {
                  final contact = contactList[0][index];
                  return InkWell(
                    onTap: () => selectContact(index, contact),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          contact.username,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: selectedContactsIndex.contains(index)
                            ? IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.done),
                              )
                            : null,
                      ),
                    ),
                  );
                }),
          ),
          error: (err, trace) => ErrorScreen(
            error: err.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
