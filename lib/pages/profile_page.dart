import 'package:anitocorn_firebase_auth_bloc/blocs/auth/auth_bloc.dart';
import 'package:anitocorn_firebase_auth_bloc/blocs/profile/profile_cubit.dart';
import 'package:anitocorn_firebase_auth_bloc/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/my_theme.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  void _getProfile() {
    final String uid = context.read<AuthBloc>().state.user!.uid;
    print('uid: $uid');
    context.read<ProfileCubit>().getProfile(uid: uid);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
         automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          // title: Text('Profile'),
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.profileStatus == ProfileStatus.error) {
              errorDialog(context, state.error);
            }
          },
          builder: (context, state) {
            if (state.profileStatus == ProfileStatus.initial) {
              return Container();
            } else if (state.profileStatus == ProfileStatus.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.profileStatus == ProfileStatus.error) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/error.png',
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 20.0),
                    Text(
                      'Ooops!\nTry again',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                buildProfileCard(state),
                SizedBox(height: 20.0),
                buildButton(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Card buildProfileCard(ProfileState state) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInImage.assetNetwork(
            placeholder: 'assets/images/loading.gif',
            image: state.user.profileImage,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '-id: ${state.user.id}',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '- name: ${state.user.name}',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '- email: ${state.user.email}',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '- point: ${state.user.point}',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '- rank: ${state.user.rank}',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Row buildButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: const EdgeInsets.only(top: 8.0),
        // width: size * 0.9,
        width: 250.0,
        height: 50.0,
        decoration: _boxDecoration(),
        child: TextButton(
          onPressed: () {
            context.read<AuthBloc>().add(SignoutRequestedEvent());
          },
          child: Text(
            'Log Out',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          // style: TextButton.styleFrom(
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(8.0),
          //   ),
          //   backgroundColor: Colors.black,
          //   textStyle: TextStyle(
          //     fontSize: 20.0,
          //     fontWeight: FontWeight.bold,
          //   ),
          //   padding: const EdgeInsets.symmetric(vertical: 10.0),
          // ),
        ),
      ),
    ],
  );
}

BoxDecoration _boxDecoration() {
  final colors = MyTheme.blackColor;

  boxShadowItem(Color color) => BoxShadow(
        color: color,
        blurRadius: 10.0,
      );

  return BoxDecoration(
    borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    ),
    boxShadow: [
      boxShadowItem(colors),
    ],
    color: colors,
  );
}
