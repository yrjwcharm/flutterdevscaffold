import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterdevscaffold/app/http/token_manager.dart';

enum LoginStage { method, phone, code, success }

class LoginState {
  const LoginState({
    this.stage = LoginStage.method,
    this.phoneNumber = '',
    this.code = '',
    this.isAgreementAccepted = false,
    this.isSendingCode = false,
    this.isVerifying = false,
    this.countdown = 0,
    this.errorMessage,
  });

  final LoginStage stage;
  final String phoneNumber;
  final String code;
  final bool isAgreementAccepted;
  final bool isSendingCode;
  final bool isVerifying;
  final int countdown;
  final String? errorMessage;

  bool get isPhoneValid => RegExp(r'^\d{11}$').hasMatch(phoneNumber);
  bool get isCodeValid => RegExp(r'^\d{6}$').hasMatch(code);
  bool get canSendCode =>
      isAgreementAccepted && isPhoneValid && !isSendingCode && countdown == 0;
  bool get canVerify => isCodeValid && !isVerifying;

  LoginState copyWith({
    LoginStage? stage,
    String? phoneNumber,
    String? code,
    bool? isAgreementAccepted,
    bool? isSendingCode,
    bool? isVerifying,
    int? countdown,
    Object? errorMessage = _unchanged,
  }) {
    return LoginState(
      stage: stage ?? this.stage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      code: code ?? this.code,
      isAgreementAccepted:
          isAgreementAccepted ?? this.isAgreementAccepted,
      isSendingCode: isSendingCode ?? this.isSendingCode,
      isVerifying: isVerifying ?? this.isVerifying,
      countdown: countdown ?? this.countdown,
      errorMessage: identical(errorMessage, _unchanged)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

const Object _unchanged = Object();

final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, LoginState>(
  (ref) => LoginViewModel(),
);

class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel() : super(const LoginState());

  Timer? _timer;

  void toggleAgreement(bool? value) {
    state = state.copyWith(
      isAgreementAccepted: value ?? false,
      errorMessage: null,
    );
  }

  void startPhoneLogin() {
    if (!state.isAgreementAccepted) {
      state = state.copyWith(errorMessage: '请先阅读并同意用户协议和隐私政策');
      return;
    }
    state = state.copyWith(stage: LoginStage.phone, errorMessage: null);
  }

  void updatePhone(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    state = state.copyWith(phoneNumber: digits, errorMessage: null);
  }

  void updateCode(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    state = state.copyWith(code: digits, errorMessage: null);
  }

  void back() {
    switch (state.stage) {
      case LoginStage.method:
        return;
      case LoginStage.phone:
        state = state.copyWith(stage: LoginStage.method, errorMessage: null);
      case LoginStage.code:
        state = state.copyWith(
          stage: LoginStage.phone,
          code: '',
          errorMessage: null,
        );
      case LoginStage.success:
        state = state.copyWith(stage: LoginStage.code, errorMessage: null);
    }
  }

  Future<void> sendCode() async {
    if (!state.isAgreementAccepted) {
      state = state.copyWith(errorMessage: '请先阅读并同意用户协议和隐私政策');
      return;
    }

    if (!state.isPhoneValid) {
      state = state.copyWith(errorMessage: '请输入 11 位手机号');
      return;
    }

    if (state.countdown > 0 || state.isSendingCode) {
      return;
    }

    state = state.copyWith(isSendingCode: true, errorMessage: null);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) {
      return;
    }

    state = state.copyWith(
      stage: LoginStage.code,
      isSendingCode: false,
      countdown: 60,
      errorMessage: null,
    );
    _startCountdown();
  }

  Future<void> verifyCode() async {
    if (!state.isCodeValid) {
      state = state.copyWith(errorMessage: '请输入 6 位验证码');
      return;
    }

    final phoneNumber = state.phoneNumber;
    state = state.copyWith(isVerifying: true, errorMessage: null);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) {
      return;
    }

    await TokenManager.saveToken(
      access: 'mock_access_token_$phoneNumber',
      refresh: 'mock_refresh_token_$phoneNumber',
    );
    if (!mounted) {
      return;
    }

    _timer?.cancel();
    state = state.copyWith(
      stage: LoginStage.success,
      isVerifying: false,
      countdown: 0,
      errorMessage: null,
    );
  }

  void resetToMethod() {
    _timer?.cancel();
    state = const LoginState();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final next = state.countdown - 1;
      if (next <= 0) {
        timer.cancel();
        state = state.copyWith(countdown: 0);
        return;
      }
      state = state.copyWith(countdown: next);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
