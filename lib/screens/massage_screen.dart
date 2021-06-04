import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import '../providers/contact.dart' as contactProvider;
import '../components/warning_popup.dart';
import '../constants/constant.dart';
import '../screens/history_screen.dart';
import '../widgets/widgets.dart';

class MassageScreen extends StatefulWidget {
  static const String routeName = 'masssage-screen';
  @override
  _MassageScreenState createState() => _MassageScreenState();
}

class _MassageScreenState extends State<MassageScreen> {
  TextEditingController _messageController = TextEditingController();
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

  Future<void> _submitData() async {
    if (_messageController.text.isEmpty) {
      WarningPopup.showWarningDialog(
          context, false, 'Phone Number Required', () {});
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      var success = await Provider.of<User>(context, listen: false)
          .changeMassage(_messageController.text);
      if (success) {
        WarningPopup.showWarningDialog(
            context, true, 'Massage Updated Successfully', () => {});
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
    final user = Provider.of<User>(context);
    final myAddedContacts = Provider.of<contactProvider.Contact>(context).items;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Massege',
            style: TextStyle(
                color: black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              },
              child: Text(
                'Add New Contact',
                style: TextStyle(
                  color: grey,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        body: _isLoading
            ? Center(child: const CircularProgressIndicator())
            : Column(
                children: [
                  SizedBox(height: 40),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    height: 150,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Form(
                          child: TextField(
                            controller: _messageController
                              ..text = user.userData.smsAlert,
                            decoration: InputDecoration.collapsed(
                              hintText: "Write Your own Message",
                              hintStyle: TextStyle(
                                color: grey,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: CommonButton(
                      child: Text('Save '),
                      onPressed: () => _submitData(),
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    child: Text("This is your message that send to",
                        style: TextStyle(
                          fontSize: 12,
                          color: grey,
                        )),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'Conacts',
                        style: TextStyle(
                          fontSize: 15,
                          color: primary,
                        ),
                        children: [
                          TextSpan(
                            text: ' To get  ',
                            style: TextStyle(
                              fontSize: 15,
                              color: grey,
                            ),
                          ),
                          TextSpan(
                            text: 'help',
                            style: TextStyle(
                              fontSize: 15,
                              color: primary,
                            ),
                          ),
                        ]),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: myAddedContacts.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        var contact = myAddedContacts[index];
                        return ListTile(
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
                            ),
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
}
