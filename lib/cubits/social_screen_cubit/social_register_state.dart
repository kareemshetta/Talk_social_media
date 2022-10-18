abstract class SocialRegisterState {}

class SocialRegisterLoadingState extends SocialRegisterState {}

class SocialRegisterSuccessState extends SocialRegisterState {
  final String uId;
  SocialRegisterSuccessState(this.uId);
}

class SocialRegisterErrorState extends SocialRegisterState {
  final String message;
  SocialRegisterErrorState(this.message);
}

class SocialRegisterInitialState extends SocialRegisterState {}

class SocialRegisterToggleVisibilityState extends SocialRegisterState {}

class SocialCreateNewUserSuccessState extends SocialRegisterState {}
