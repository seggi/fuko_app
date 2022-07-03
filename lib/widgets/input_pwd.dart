import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/style.dart';

class PwdInputField extends StatefulWidget {
  final TextEditingController passwordController;

  const PwdInputField({Key? key, required this.passwordController})
      : super(key: key);

  @override
  _PwdInputFieldState createState() => _PwdInputFieldState();
}

class _PwdInputFieldState extends State<PwdInputField> {
  bool _passwordVisibility = false;

  @override
  void initState() {
    setState(() {
      _passwordVisibility = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = widget.passwordController;
    return TextFormField(
      controller: passwordController,
      keyboardType: TextInputType.text,
      obscureText: _passwordVisibility,
      decoration: InputDecoration(
        hintText: 'Password',
        suffixIcon: IconButton(
            onPressed: () {
              // Get password visibility bool var
              setState(() {
                _passwordVisibility = !_passwordVisibility;
              });
            },
            icon: Icon(
                !_passwordVisibility ? Icons.visibility : Icons.visibility_off,
                color: fkDefaultColor)),
        border: OutlineInputBorder(
            borderSide:
                const BorderSide(color: fkInputFormBorderColor, width: 1.0),
            borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }
}
