import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';

import '../blocs/auth.dart';
import '../blocs/signup/signup_cubit.dart';
import '../blocs/signup/signup_cubit.dart';
import '../utils/error_dialog.dart';
import 'pages.dart';

class SignupPage extends StatefulWidget {
  static const String routeName = '/signup';
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final passwordController = TextEditingController();
  String? name, email, password;

  void submit() {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });
    final form = formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    print('name: $name!,email: $email, password: $password');

    context.read<SignupCubit>().signup(
          name: name!,
          email: email!,
          password: password!,
        );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state.signupStatus == SignupStatus.error) {
            errorDialog(context, state.error);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: Form(
                key: formKey,
                autovalidateMode: autovalidateMode,
                child: ListView(
                  shrinkWrap: true,
                  reverse: true,
                  children: [
                    buildImage(),
                    SizedBox(height: 8.0),
                    buildName(size),
                    SizedBox(height: 8.0),
                    buildEmail(size),
                    SizedBox(height: 8.0),
                    buildPassword(size),
                    SizedBox(height: 8.0),
                    buildConfirmPassword(size),
                    SizedBox(height: 8.0),
                    buildButton(state, size),
                    SizedBox(height: 10.0),
                    buildTitle(state, context),
                  ].reversed.toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Row buildTitle(SignupState state, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already a member?',
          style: TextStyle(
            fontSize: 20.0,
            decoration: TextDecoration.underline,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: state.signupStatus == SignupStatus.submitting
              ? null
              : () {
                  Navigator.pop(context);
                },
          child: Text(
            'Sign In!',
            style: TextStyle(
              fontSize: 20.0,
              // decoration: TextDecoration.underline,
              color: Colors.deepOrange,
            ),
          ),
        ),
      ],
    );
  }

  Row buildButton(SignupState state, double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          // padding: const EdgeInsets.only(left: 20.0),
          width: size * 0.9,
          child: ElevatedButton(
            onPressed:
                state.signupStatus == SignupStatus.submitting ? null : submit,
            child: Text(state.signupStatus == SignupStatus.submitting
                ? 'Loading...'
                : 'Sign Up'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: Colors.blueAccent.shade400,
              textStyle: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10.0),
            ),
          ),
        ),
      ],
    );
  }

  Row buildConfirmPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          // padding: const EdgeInsets.only(left: 20.0),
          width: size * 0.9,
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              labelText: 'Confirm Password',
              labelStyle: TextStyle(color: Colors.black),
              prefixIcon: Icon(
                Icons.password,
                color: Colors.black,
              ),
            ),
            validator: (String? value) {
              if (passwordController.text != value) {
                return 'Password not match';
              }

              return null;
            },
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              8.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.5),
                spreadRadius: 5.0,
                blurRadius: 15.0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          // padding: const EdgeInsets.only(left: 20.0),
          width: size * 0.9,
          child: TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.black),
              prefixIcon: Icon(
                Icons.password,
                color: Colors.black,
              ),
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Password required';
              }
              if (value.trim().length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            onSaved: (String? value) {
              password = value;
            },
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              8.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.5),
                spreadRadius: 5.0,
                blurRadius: 15.0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row buildEmail(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          // padding: const EdgeInsets.only(left: 20.0),
          width: size * 0.9,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.black),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.black,
              ),
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email requied';
              }
              if (!isEmail(value.trim())) {
                return 'Enter a valid email';
              }
              return null;
            },
            onSaved: (String? value) {
              email = value;
            },
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              8.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.5),
                spreadRadius: 5.0,
                blurRadius: 15.0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row buildName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          // padding: const EdgeInsets.only(left: 20.0),
          width: size * 0.9,
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.black),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name requied';
              }
              if (value.trim().length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
            onSaved: (String? value) {
              name = value;
            },
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              8.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.5),
                spreadRadius: 5.0,
                blurRadius: 15.0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Image buildImage() {
    return Image.network(
      'https://www.pngmart.com/files/21/Internet-Of-Things-IOT-Vector-PNG-Picture.png',
      // 'https://www.nicepng.com/png/full/428-4288965_internet-of-things-iot-sensor.png',
      // 'https://www.alifitsolutions.com/public/user/images/IOT%20(1).png',
      width: 300,
      height: 300,
    );
  }
}
