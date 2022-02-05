import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/style.dart';

class EmailInputFeild extends StatefulWidget {
  TextEditingController emailController;
  EmailInputFeild({Key? key, required this.emailController}) : super(key: key);

  @override
  _EmailInputFeildState createState() => _EmailInputFeildState();
}

class _EmailInputFeildState extends State<EmailInputFeild> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = widget.emailController;
    return Container(
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            hintText: 'example@fuko.com',
            suffixIcon: Icon(Icons.email, color: fkDefaultColor),
            border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: fkInputFormBorderColor, width: 1.0),
                borderRadius: BorderRadius.circular(8.0))),
      ),
    );
  }
}
