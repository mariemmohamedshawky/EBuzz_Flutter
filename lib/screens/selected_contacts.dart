import 'package:ebuzz/screens/contacts_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import '../providers/contact.dart' as contactProvider;
import '../components/warning_popup.dart';
import '../constants/constant.dart';
class SelectedContactsScreen extends StatefulWidget {
  static const String routeName = 'selected-contacts-screen';
  @override
  _SelectedContactsScreenState createState() =>  _SelectedContactsScreenState();
}

class  _SelectedContactsScreenState extends State<SelectedContactsScreen> {
  var _isLoading = false;

  @override
  void initState() {
    getAddedContacts();
    super.initState();
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
  Future<void> _deleteContact(int id) async {
    if (id == null) {
      WarningPopup.showWarningDialog(
          context, false, 'Phone Number Required', () {});
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      var success =
          await Provider.of<contactProvider.Contact>(context, listen: false)
              .deleteContact(id);
      if (success) {
        WarningPopup.showWarningDialog(
            context, true, 'Contact Deleted Successfully', () => {});
      } else {
        WarningPopup.showWarningDialog(context, false,
            Provider.of<User>(context, listen: false).errorMessage, () {});
      }
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

  @override
  Widget build(BuildContext context) {
   // final user = Provider.of<User>(context);
    final myAddedContacts = Provider.of<contactProvider.Contact>(context).items;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          'My Contacts',
          style: TextStyle(
              color: black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
           IconButton(
          icon: Icon(
            Icons.add_call,
            color: primary,
          ),
          onPressed: () async {
          final PermissionStatus permissionStatus = await _getPermission();
          if (permissionStatus == PermissionStatus.granted) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ContactsScreen()));
          } else {
            if (await Permission.contacts.request().isGranted) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactsScreen()));
            }
          }
        },
        ),
        
        ],
      ),
      body: Container(
        child: _isLoading
            ? Center(child: const CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                      itemCount: myAddedContacts.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        var contact = myAddedContacts[index];
                        return Card(
                          shadowColor: Color(0xFFf25757),
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: ListTile(
                            leading: IconButton(
                              onPressed: () async {
                                _deleteContact(contact.id);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red[300],
                                size: 30,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 18),
                            title: Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(contact.fullName,
                                    style: TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(contact.phone,
                                    style:
                                        TextStyle(color: black, fontSize: 14)),
                              ],
                            )),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
      ),
    );
    
  }
   Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.granted;
    } else {
      return permission;
    }
  }
}