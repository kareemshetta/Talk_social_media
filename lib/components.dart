import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void navigateAndReplace(BuildContext context, Widget screen) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => screen), (route) => false);
}

void navigateNamed(BuildContext context, String routeName, {dynamic args}) {
  Navigator.of(context).pushNamed(routeName, arguments: args);
}

void navigateAndReplacementNamed(
    {required BuildContext context, dynamic args, required String routeName}) {
  Navigator.of(context).pushReplacementNamed(routeName, arguments: args);
}

Widget buildDefaultTextButton(void Function()? onPressed, String text) {
  return TextButton(onPressed: onPressed, child: Text(text.toUpperCase()));
}

Widget buildDefaultTextFormField(
    {required TextEditingController controller,
    required String? Function(String? value)? validator,
    bool isPassword = false,
    bool isEnable = true,
    void Function()? onTap,
    void Function(String value)? onChange,
    void Function(String value)? onSubmit,
    required String labelText,
    TextInputType keyBoardType = TextInputType.text,
    Widget? suffixIcon,
    Widget? prefixIcon}) {
  return TextFormField(
    enabled: isEnable,
    onFieldSubmitted: onSubmit,
    onChanged: onChange,
    onTap: onTap,
    controller: controller,
    validator: validator,
    obscureText: isPassword,
    keyboardType: keyBoardType,
    decoration: InputDecoration(
      label: Text(labelText),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(),
    ),
  );
}

Widget defaultButton(
    {required void Function()? onPressed,
    required String buttonTitle,
    bool isUpper = false,
    Color buttonTextColor = Colors.white,
    Color color = Colors.lightBlue,
    double width = double.infinity}) {
  return Container(
    color: color,
    width: width,
    child: MaterialButton(
      onPressed: onPressed,
      child: Text(
        isUpper ? buttonTitle.toUpperCase() : buttonTitle,
        style: TextStyle(color: buttonTextColor),
      ),
    ),
  );
}

Widget buildHorizontalDivider() {
  return Padding(
    padding: const EdgeInsets.only(left: 20),
    child: Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey,
    ),
  );
}

void buildToast(String msg, Color toastColor) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 5,
      backgroundColor: toastColor,
      textColor: Colors.white,
      fontSize: 16.0);
}
