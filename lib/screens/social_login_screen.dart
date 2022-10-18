import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/screens/register_screen.dart';
import 'package:social_media_app/cubits/social_screen_cubit/social_login_state.dart';
import 'package:social_media_app/cubits/social_screen_cubit/social_login_cubit.dart';
import 'package:social_media_app/components.dart';
import '../layout/home_screen.dart';

class LoginSocialScreen extends StatelessWidget {
  LoginSocialScreen({Key? key}) : super(key: key);
  static const routeName = 'Social-login';

  final passwordController = TextEditingController();
  final emailAddressController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  // bool isPass=false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginState>(
        listener: (context, state) {
          if (state is SocialLoginErrorState) {
            buildToast(state.message, Colors.red);
          }
          if (state is SocialLoginSuccessState) {
            final socialCubit = SocialLoginCubit.get(context);
            // socialCubit.g
            navigateAndReplacementNamed(
                context: context, routeName: HomeScreen.routeName);
            buildToast('login successfully', Colors.green);
          }
        },
        builder: (context, state) {
          final socialCubit = SocialLoginCubit.get(context);
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
                          'LOGIN',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'login now to browse our hot offers',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey),
                        ),
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
                            onSubmit: (value) async {
                              if (!formKey.currentState!.validate()) {
                                return;
                              } else {
                                final data = await SocialLoginCubit.get(context)
                                    .loginUser(
                                        context: context,
                                        email: emailAddressController.text,
                                        password: passwordController.text);
                              }
                            },
                            labelText: 'password'),
                        SizedBox(
                          height: 20,
                        ),
                        ConditionalBuilder(
                            condition: state is! SocialLoginLoadingState,
                            builder: (ctx) {
                              return defaultButton(
                                  onPressed: () async {
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    } else {
                                      try {
                                        await SocialLoginCubit.get(context)
                                            .loginUser(
                                                context: context,
                                                email:
                                                    emailAddressController.text,
                                                password:
                                                    passwordController.text);
                                      } catch (error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'check your credential')));
                                      }
                                    }
                                  },
                                  buttonTitle: 'login',
                                  isUpper: true);
                            },
                            fallback: (ctx) {
                              return Center(child: CircularProgressIndicator());
                            }),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account?'),
                            buildDefaultTextButton(() {
                              navigateAndReplacementNamed(
                                  context: context,
                                  routeName: RegisterSocialScreen.routeName);
                            }, 'register')
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
