import 'package:anitocorn_firebase_auth_bloc/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';

import '../blocs/signin/signin_cubit.dart';
import '../utils/utils.dart';

class SigninPage extends StatefulWidget {
  static const String routeName = '/signin';
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? email, password;
  bool statusRedEye = true;

  void submit() {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });
    final form = formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    print('email: $email, password: $password');

    context.read<SigninCubit>().signin(email: email!, password: password!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SigninCubit, SigninState>(
          listener: (context, state) {
            if (state.signinStatus == SigninStatus.error) {
              errorDialog(context, state.error);
            }
          },
          builder: (context, state) {
            double size = MediaQuery.of(context).size.width;
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
                      SizedBox(height: 20.0),
                      buildEmail(size),
                      SizedBox(height: 8.0),
                      buildPassword(size),
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
      ),
    );
  }

  Row buildTitle(SigninState state, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Not a member?',
          style: TextStyle(
            fontSize: 20.0,
            decoration: TextDecoration.underline,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: state.signinStatus == SigninStatus.submitting
              ? null
              : () {
                  Navigator.pushNamed(context, SignupPage.routeName);
                },
          child: Text(
            'Sign Up!',
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

  Row buildButton(SigninState state, double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
           margin: const EdgeInsets.only(top: 8.0),
          width: size * 0.9,
          child: ElevatedButton(
            onPressed:
                state.signinStatus == SigninStatus.submitting ? null : submit,
            child: Text(state.signinStatus == SigninStatus.submitting
                ? 'Loading...'
                : 'Sign In'),
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

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          // padding: const EdgeInsets.only(left: 20.0),
          width: size * 0.9,
          child: TextFormField(
            obscureText: statusRedEye,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    statusRedEye = !statusRedEye;
                  });
                },
                icon: statusRedEye
                    ? Icon(Icons.remove_red_eye, color: Colors.black)
                    : Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.black,
                      ),
              ),
              border: InputBorder.none,
              filled: true,
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.black),
              prefixIcon: Icon(Icons.password, color: Colors.black),
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Password required';
              }
              if (value.trim().length < 6) {
                return 'Password must be at least 6 characters long';
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

  Image buildImage() {
    return Image.network(
      'https://www.pngmart.com/files/21/Internet-Of-Things-IOT-Vector-PNG-Picture.png',
      // 'https://www.nicepng.com/png/full/428-4288965_internet-of-things-iot-sensor.png',
      // 'https://www.alifitsolutions.com/public/user/images/IOT%20(1).png',
      width: 300,
      height: 300,
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
              // hintText: 'Email',
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
}
