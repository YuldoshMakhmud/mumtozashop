import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mumtozashop/viewModel/user_view_model.dart';
import '../../../../providers/user_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final formGlobalKey = GlobalKey<FormState>();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController addressTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();

  UserViewModel userViewModel = UserViewModel();

  @override
  void initState() {
    final userInfo = Provider.of<UserProvider>(context, listen: false);
    nameTextEditingController.text = userInfo.nameOfUser;
    emailTextEditingController.text = userInfo.emailOfUser;
    addressTextEditingController.text = userInfo.addressOfUser;
    phoneTextEditingController.text = userInfo.phoneNumberOfUser;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formGlobalKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: nameTextEditingController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Name cannot be empty." : null,
                ),
                SizedBox(height: 10),

                TextFormField(
                  controller: emailTextEditingController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Email cannot be empty." : null,
                ),

                SizedBox(height: 10),

                TextFormField(
                  maxLines: 3,
                  controller: addressTextEditingController,
                  decoration: InputDecoration(
                    labelText: "Address",
                    hintText: "Address",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Address cannot be empty." : null,
                ),

                SizedBox(height: 10),

                TextFormField(
                  controller: phoneTextEditingController,
                  decoration: InputDecoration(
                    labelText: "Phone",
                    hintText: "Phone",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Phone cannot be empty." : null,
                ),

                SizedBox(height: 10),

                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * .9,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formGlobalKey.currentState!.validate()) {
                        var userData = {
                          "name": nameTextEditingController.text,
                          "email": emailTextEditingController.text,
                          "address": addressTextEditingController.text,
                          "phone": phoneTextEditingController.text,
                        };

                        await userViewModel.updateUserData(userData: userData);

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Profile Updated")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      "Update Profile",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
