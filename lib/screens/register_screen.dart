import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:social_media_app/layout/home_screen.dart';
import 'package:social_media_app/cubits/social_screen_cubit/social_register_state.dart';
import 'package:social_media_app/cubits/social_screen_cubit/social_register_cubit.dart';
import 'package:social_media_app/screens/social_login_screen.dart';

import '../components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterSocialScreen extends StatelessWidget {
  RegisterSocialScreen({Key? key}) : super(key: key);
  static const routeName = 'SocialRegisterScreen';

  final passwordController = TextEditingController();
  final emailAddressController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  // bool isPass=false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterState>(
        listener: (context, state) {
          if (state is SocialRegisterErrorState) {
            buildToast(state.message, Colors.red);
          }
          if (state is SocialRegisterSuccessState) {
            buildToast('register successfully', Colors.green);
          }
        },
        builder: (context, state) {
          final socialCubit = SocialRegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'Register now to share your posts',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        buildDefaultTextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'you must enter name';
                              }
                              return null;
                            },
                            keyBoardType: TextInputType.emailAddress,
                            prefixIcon: Icon(Icons.person),
                            labelText: 'name'),
                        SizedBox(
                          height: 20,
                        ),
                        buildDefaultTextFormField(
                            controller: emailAddressController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'you must enter email address';
                              }
                              return null;
                            },
                            keyBoardType: TextInputType.emailAddress,
                            prefixIcon: Icon(Icons.email_outlined),
                            labelText: 'email address'),
                        SizedBox(
                          height: 10,
                        ),
                        buildDefaultTextFormField(
                          labelText: 'password',
                          keyBoardType: TextInputType.visiblePassword,
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                socialCubit.toggleVisibility();
                              },
                              icon: Icon(socialCubit.visibilityIcon)),
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'you must enter password';
                            }
                            return null;
                          },
                          isPassword: socialCubit.isPassword,
                          onSubmit: (value) async {},
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        buildDefaultTextFormField(
                            controller: phoneController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'you must enter phone number';
                              }
                              return null;
                            },
                            keyBoardType: TextInputType.number,
                            prefixIcon: Icon(Icons.phone),
                            labelText: 'phone number'),
                        SizedBox(
                          height: 10,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialRegisterLoadingState,
                          builder: (ctx) {
                            return defaultButton(
                                onPressed: () async {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  } else {
                                    try {
                                      await SocialRegisterCubit.get(context)
                                          .registerUser(
                                        context: context,
                                        email: emailAddressController.text,
                                        password: passwordController.text,
                                        name: nameController.text,
                                        phoneNumber: phoneController.text,
                                      );
                                      navigateAndReplacementNamed(
                                          context: context,
                                          routeName: HomeScreen.routeName);
                                    } catch (err) {}
                                  }
                                },
                                buttonTitle: 'Register',
                                isUpper: true);
                          },
                          fallback: (ctx) {
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('you have an account?'),
                            buildDefaultTextButton(() {
                              navigateAndReplacementNamed(
                                  context: context,
                                  routeName: LoginSocialScreen.routeName);
                            }, 'login')
                          ],
                        )
                      ],
                    ),
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
