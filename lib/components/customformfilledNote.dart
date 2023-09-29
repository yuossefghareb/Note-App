import 'package:flutter/material.dart';

class CustomTextFormNote extends StatelessWidget {
  final String hinttext;
  final bool? obscure;
 
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;

  const CustomTextFormNote({
    super.key,
    required this.hinttext,
    required this.mycontroller,
    required this.validator,  this.obscure, required TextEditingController controller, required TextInputType keyboardType, required maxLines,
    
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
     
      controller: mycontroller,
      validator: validator,
      
      obscureText: obscure ?? false,
      decoration: InputDecoration(
       
          hintText: hinttext,
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
