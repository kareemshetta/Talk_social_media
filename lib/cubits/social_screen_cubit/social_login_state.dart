abstract class SocialLoginState {}

class SocialLoginLoadingState extends SocialLoginState {}

class SocialLoginSuccessState extends SocialLoginState {
  final String uId;
  SocialLoginSuccessState(this.uId);
}

class SocialLoginErrorState extends SocialLoginState {
  final String message;
  SocialLoginErrorState(this.message);
}

class SocialLoginInitialState extends SocialLoginState {}

class SocialToggleVisibilityState extends SocialLoginState {}

class GetCurrentUserDataChangeState extends SocialLoginState {}
