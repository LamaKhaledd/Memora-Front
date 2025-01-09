
import 'package:flutter/material.dart';

class EditParent extends StatefulWidget {
  final String name;
  final String address;
  final String phone;
  final String email;

  EditParent({
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
  });

  @override
  _EditParentInfoPageState createState() => _EditParentInfoPageState();
}

class _EditParentInfoPageState extends State<EditParent> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _address;
  late String _phone;
  late String _email;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _address = widget.address;
    _phone = widget.phone;
    _email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Parent Info"),
        backgroundColor: Color(0xFF4F3466),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name Field
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) =>
                value == null || value.isEmpty ? "Please enter your name" : null,
                onSaved: (value) => _name = value!,
              ),
              SizedBox(height: 15),

              // Address Field
              TextFormField(
                initialValue: _address,
                decoration: InputDecoration(labelText: "Address"),
                validator: (value) =>
                value == null || value.isEmpty ? "Please enter your address" : null,
                onSaved: (value) => _address = value!,
              ),
              SizedBox(height: 15),

              // Phone Field
              TextFormField(
                initialValue: _phone,
                decoration: InputDecoration(labelText: "Phone"),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value == null || value.isEmpty ? "Please enter your phone number" : null,
                onSaved: (value) => _phone = value!,
              ),
              SizedBox(height: 15),

              // Email Field
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Please enter a valid email address";
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              SizedBox(height: 30),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(context, {
                      'name': _name,
                      'address': _address,
                      'phone': _phone,
                      'email': _email,
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4F3466),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
