import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';

import '../blocs/signup/signup_cubit.dart';
import '../blocs/signup/signup_cubit.dart';
import '../utils/error_dialog.dart';

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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: formKey,
                  autovalidateMode: autovalidateMode,
                  child: ListView(
                    shrinkWrap: true,
                    reverse: true,
                    children: [
                      Image.network(
                        'https://www.pngmart.com/files/21/Internet-Of-Things-IOT-Vector-PNG-Picture.png',
                        // 'https://www.nicepng.com/png/full/428-4288965_internet-of-things-iot-sensor.png',
                        // 'https://www.alifitsolutions.com/public/user/images/IOT%20(1).png',
                        width: 300,
                        height: 300,
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.account_box),
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
                      SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
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
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
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
                      SizedBox(height: 20.0),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (String? value) {
                          if (passwordController.text != value) {
                            return 'Password not match';
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: state.signupStatus == SignupStatus.submitting
                            ? null
                            : submit,
                        child: Text(
                            state.signupStatus == SignupStatus.submitting
                                ? 'Loading...'
                                : 'Sign In'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent.shade400,
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
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
                            onPressed:
                                state.signupStatus == SignupStatus.submitting
                                    ? null
                                    : () {
                                        Navigator.pushNamed(
                                            context, SignupPage.routeName);
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
                        ].reversed.toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
