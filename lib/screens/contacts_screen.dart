import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';

import './home_screen.dart';
import '../components/warning_popup.dart';
import '../constants/constant.dart';
import '../providers/contact.dart' as contactProvider;

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  Iterable<Contact> _contacts;
  List<int> selectedContacts = [];
  List<Map<String, String>> mapContacts = [];
  var _isLoading = false;

  @override
  void initState() {
    getContacts();
    getAddedContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    //We already have permissions for contact when we get to this page, so we
    // are now just retrieving it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  Future<void> getAddedContacts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<contactProvider.Contact>(context, listen: false)
          .viewContacts();
    } catch (error) {
      print(error);
      WarningPopup.showWarningDialog(
          context, false, 'SomeThing Went Wrong..', () {});
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _submitData(contacts) async {
    if (contacts.length < 1) {
      WarningPopup.showWarningDialog(
          context, false, 'Please Select Contact', () {});
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var success =
          await Provider.of<contactProvider.Contact>(context, listen: false)
              .addContacts(contacts);
      if (success) {
        WarningPopup.showWarningDialog(
            context,
            true,
            'Contacts Added Successfully',
            () => Navigator.of(context).pushNamed(HomeScreen.routeName));
      } else {
        WarningPopup.showWarningDialog(
            context,
            false,
            Provider.of<contactProvider.Contact>(context, listen: false)
                .errorMessage,
            () {});
      }
    } catch (error) {
      print(error);
      WarningPopup.showWarningDialog(
          context, false, 'SomeThing Went Wrong..', () {});
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final myAddedContacts = Provider.of<contactProvider.Contact>(context).items;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: grey,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'All Contacts',
          style: TextStyle(
              color: black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
             SizedBox(
              width:81,
              child: IconButton( 
               icon: Icon (Icons.assignment_turned_in_outlined),
                color: primary,
                onPressed: () {
              print(mapContacts);
              _submitData(mapContacts);
            },
              ),
            ),
        ],
      ),
      body: _contacts != null && _isLoading == false
          //Build a list view of all contacts, displaying their avatar and
          // display name
          ? ListView.builder(
              itemCount: _contacts?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = _contacts?.elementAt(index);
                var tempC = myAddedContacts.where((element) =>
                    element.phone == contact.phones.first.value.toString());
                return tempC.isNotEmpty
                    ? SizedBox(
                        width: 0,
                      )
                    : ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 18),
                        leading: (contact.avatar != null &&
                                contact.avatar.isNotEmpty)
                            ? CircleAvatar(
                                backgroundColor: white,
                                backgroundImage: MemoryImage(contact.avatar),
                              )
                            : CircleAvatar(
                                child: Text(
                                  contact.initials(),
                                  style: TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                
                                backgroundColor: primary,
                              ),
                        trailing: Checkbox(
                            activeColor: selectedContacts.contains(index)
                                ? primary
                                : Colors.white,
                            value: selectedContacts.contains(index),
                            onChanged: (bool value) {
                              setState(() {
                                if (selectedContacts.contains(index)) {
                                  selectedContacts.remove(index);
                                  mapContacts.removeWhere((element) =>
                                      element['phone'] ==
                                      contact.phones.first.value.toString());
                                  print(mapContacts);
                                } else {
                                  selectedContacts.add(index);
                                  Map tempContact = Map<String, String>();
                                  tempContact['phone'] =
                                      contact.phones.first.value.toString() ??
                                          '';
                                  tempContact['first_name'] =
                                      contact.givenName ?? '';
                                  tempContact['last_name'] =
                                      contact.familyName != null
                                          ? contact.familyName
                                          : '.';
                                  mapContacts.add(tempContact);
                                  print(contact.familyName);
                                  print(mapContacts);
                                }
                              });
                            }),
                        title: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(contact.displayName ?? '',
                                    style: TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(
                                    contact.phones.first.value.toString() ?? '',
                                    style:
                                        TextStyle(color: black, fontSize: 14)),
                              ],
                            ),
                          ),
                        
                      );
              },
            )
          : Center(child: const CircularProgressIndicator()),
    );
  }
}