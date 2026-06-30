import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutterdevscaffold/app/common/app_theme.dart';
import 'package:flutterdevscaffold/app/router/app_router.dart';
import 'package:flutterdevscaffold/app/viewmodel/login_viewmodel.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(
      loginViewModelProvider.select((state) => state.errorMessage),
      (previous, next) {
        if (next == null || next == previous) {
          return;
        }
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(next)));
      },
    );

    final state = ref.watch(loginViewModelProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFFAFBFF), Color(0xFFF4F6FF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _AuthTopBar(stage: state.stage),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            child: KeyedSubtree(
                              key: ValueKey<LoginStage>(state.stage),
                              child: _buildStage(context, state),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStage(BuildContext context, LoginState state) {
    switch (state.stage) {
      case LoginStage.method:
        return _MethodStage(state: state);
      case LoginStage.phone:
        return _PhoneStage(state: state);
      case LoginStage.code:
        return _CodeStage(state: state);
      case LoginStage.success:
        return const _SuccessStage();
    }
  }
}

class _AuthTopBar extends ConsumerWidget {
  const _AuthTopBar({required this.stage});

  final LoginStage stage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(loginViewModelProvider.notifier);

    return SizedBox(
      height: 54,
      child: Row(
        children: [
          if (stage == LoginStage.phone || stage == LoginStage.code)
            IconButton(
              tooltip: '返回',
              onPressed: viewModel.back,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            )
          else
            const SizedBox(width: 48),
          const Spacer(),
          if (stage == LoginStage.method)
            IconButton(
              tooltip: '关闭',
              onPressed: viewModel.resetToMethod,
              icon: const Icon(Icons.close_rounded),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _MethodStage extends ConsumerWidget {
  const _MethodStage({required this.state});

  final LoginState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(loginViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Text(
          '欢迎来到 PromptHub',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          '登录后即可同步你的 Prompt 和 Skill',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 28),
        const _PromptHubIllustration(),
        const SizedBox(height: 36),
        _PrimaryActionButton(
          icon: Icons.person_rounded,
          label: '手机号验证码登录',
          onPressed: viewModel.startPhoneLogin,
        ),
        const SizedBox(height: 14),
        _SecondaryActionButton(
          icon: Icons.lock_outline_rounded,
          label: '密码登录',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('密码登录入口待接入')),
            );
          },
        ),
        const SizedBox(height: 28),
        const _DividerLabel(label: '其他登录方式'),
        const SizedBox(height: 18),
        const _SocialLoginRow(),
        const SizedBox(height: 34),
        _AgreementRow(value: state.isAgreementAccepted),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _PhoneStage extends ConsumerWidget {
  const _PhoneStage({required this.state});

  final LoginState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(loginViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Text('输入手机号', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          '未注册的手机号验证后将自动创建账号',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 38),
        _PhoneNumberField(
          value: state.phoneNumber,
          onChanged: viewModel.updatePhone,
          enabled: !state.isSendingCode,
        ),
        const SizedBox(height: 28),
        _PrimaryActionButton(
          label: state.countdown > 0
              ? '${state.countdown}s 后重新获取'
              : state.isSendingCode
                  ? '获取中...'
                  : '获取验证码',
          isLoading: state.isSendingCode,
          onPressed: state.isSendingCode || state.countdown > 0
              ? null
              : viewModel.sendCode,
        ),
        const SizedBox(height: 34),
        _AgreementRow(value: state.isAgreementAccepted),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _CodeStage extends ConsumerWidget {
  const _CodeStage({required this.state});

  final LoginState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(loginViewModelProvider.notifier);
    final codeError = state.errorMessage?.contains('验证码') ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Text('输入验证码', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          '验证码已发送至 ${_maskedPhone(state.phoneNumber)}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 38),
        _OtpCodeInput(
          value: state.code,
          hasError: codeError,
          onChanged: viewModel.updateCode,
        ),
        const SizedBox(height: 18),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: state.countdown == 0 ? viewModel.sendCode : null,
            child: Text(
              state.countdown > 0
                  ? '${state.countdown}s 后重新获取'
                  : '重新获取验证码',
            ),
          ),
        ),
        if (codeError) ...[
          const SizedBox(height: 6),
          Text(
            '验证码错误，请重新输入',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.danger,
                ),
          ),
        ],
        const SizedBox(height: 28),
        _PrimaryActionButton(
          label: state.isVerifying ? '登录中...' : '登录',
          isLoading: state.isVerifying,
          onPressed: state.canVerify ? viewModel.verifyCode : null,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SuccessStage extends ConsumerWidget {
  const _SuccessStage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 88),
        const _SuccessBadge(),
        const SizedBox(height: 30),
        Text(
          '登录成功',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Text(
          '欢迎使用 PromptHub',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 72),
        _PrimaryActionButton(
          label: '进入首页',
          onPressed: () => context.go(AppRoutes.home),
        ),
        const SizedBox(height: 14),
        _SecondaryActionButton(
          label: '去探索 Prompt',
          onPressed: () => context.go(AppRoutes.home),
        ),
        const SizedBox(height: 36),
      ],
    );
  }
}

class _PromptHubIllustration extends StatelessWidget {
  const _PromptHubIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const _LayerPlate(width: 160, height: 78, top: 74),
          const _LayerPlate(width: 128, height: 64, top: 48),
          const _LayerPlate(width: 92, height: 50, top: 26),
          Positioned(
            top: 36,
            child: Transform.rotate(
              angle: -0.25 * math.pi,
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8D99FF), AppColors.primary],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.28),
                      blurRadius: 28,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'P',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LayerPlate extends StatelessWidget {
  const _LayerPlate({
    required this.width,
    required this.height,
    required this.top,
  });

  final double width;
  final double height;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      child: Transform.rotate(
        angle: -0.25 * math.pi,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color(0xFFE5E8FF),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.14),
                blurRadius: 20,
                offset: const Offset(0, 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneNumberField extends StatefulWidget {
  const _PhoneNumberField({
    required this.value,
    required this.onChanged,
    required this.enabled,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  State<_PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<_PhoneNumberField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _PhoneNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Text(
            '+86',
            style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink),
          ),
          const Icon(Icons.arrow_drop_down_rounded, color: AppColors.ink),
          Container(width: 1, height: 20, color: AppColors.line),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: widget.enabled,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: '请输入手机号',
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: widget.onChanged,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _OtpCodeInput extends StatefulWidget {
  const _OtpCodeInput({
    required this.value,
    required this.onChanged,
    required this.hasError,
  });

  final String value;
  final bool hasError;
  final ValueChanged<String> onChanged;

  @override
  State<_OtpCodeInput> createState() => _OtpCodeInputState();
}

class _OtpCodeInputState extends State<_OtpCodeInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant _OtpCodeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: Stack(
        children: [
          Row(
            children: List.generate(6, (index) {
              final hasChar = index < widget.value.length;
              final active = index == widget.value.length && !hasChar;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index == 5 ? 0 : 8),
                  child: _OtpBox(
                    char: hasChar ? widget.value[index] : '',
                    active: active,
                    hasError: widget.hasError,
                  ),
                ),
              );
            }),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.01,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                maxLength: 6,
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.transparent),
                cursorColor: Colors.transparent,
                onChanged: widget.onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.char,
    required this.active,
    required this.hasError,
  });

  final String char;
  final bool active;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final borderColor = hasError
        ? AppColors.danger
        : active
            ? AppColors.primary
            : AppColors.line;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: active ? 1.4 : 1),
      ),
      child: Text(
        char,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
        ),
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  final String label;
  final IconData? icon;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(label),
              ],
            ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 8),
          ],
          Text(label),
        ],
      ),
    );
  }
}

class _AgreementRow extends ConsumerWidget {
  const _AgreementRow({required this.value});

  final bool value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(loginViewModelProvider.notifier);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: Checkbox(
            value: value,
            onChanged: viewModel.toggleAgreement,
            visualDensity: VisualDensity.compact,
            shape: const CircleBorder(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => viewModel.toggleAgreement(!value),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.secondaryText,
                      height: 1.55,
                    ),
                children: const [
                  TextSpan(text: '已阅读并同意 '),
                  TextSpan(
                    text: '《用户协议》',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  TextSpan(text: ' 和 '),
                  TextSpan(
                    text: '《隐私政策》',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DividerLabel extends StatelessWidget {
  const _DividerLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.line)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        const Expanded(child: Divider(color: AppColors.line)),
      ],
    );
  }
}

class _SocialLoginRow extends StatelessWidget {
  const _SocialLoginRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(
          icon: Icons.chat_bubble_rounded,
          color: Color(0xFF2CCB62),
          tooltip: '微信登录',
        ),
        SizedBox(width: 26),
        _SocialButton(
          icon: Icons.apple,
          color: Colors.black,
          tooltip: 'Apple 登录',
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.color,
    required this.tooltip,
  });

  final IconData icon;
  final Color color;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.22),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

class _SuccessBadge extends StatelessWidget {
  const _SuccessBadge();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7C8CFF), AppColors.primary],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.30),
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 52),
      ),
    );
  }
}

String _maskedPhone(String phone) {
  if (phone.length < 11) {
    return '+86 $phone';
  }
  return '+86 ${phone.substring(0, 3)}****${phone.substring(7)}';
}
