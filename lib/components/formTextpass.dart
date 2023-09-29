import 'package:firebase02/provider.dart/cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class customFormPassword extends StatelessWidget {
  final String hinttext;
  final bool obscure;
  final IconData suufixicon;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;

  const customFormPassword({
    super.key,
    required this.hinttext,
    required this.mycontroller,
    required this.validator,
   required this.obscure,
    required this.suufixicon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: mycontroller,
      validator: validator,
      obscureText: obscure ,
      decoration: InputDecoration(
          hintText: hinttext,
          suffixIcon: Consumer<MyModel>(
            builder: (context, value, child) {
              return IconButton(
                icon: Icon(suufixicon),
                onPressed: () {
                  value.chnageabs();
                },
              );
            },
          ),
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 184, 184, 184))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: Colors.grey))),
    );
  }
}
