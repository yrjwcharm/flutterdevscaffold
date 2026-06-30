import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutterdevscaffold/app/common/app_theme.dart';
import 'package:flutterdevscaffold/app/http/token_manager.dart';
import 'package:flutterdevscaffold/app/router/app_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) {
      return;
    }

    final route = TokenManager.accessToken == null
        ? AppRoutes.login
        : AppRoutes.home;
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF3F5FF), Color(0xFFE9EDFF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 430.w),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    const _PromptLogo(size: 72),
                    SizedBox(height: 18.h),
                    Text(
                      'PromptHub',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '让 AI 更懂你，让创意更高效',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    const _FloatingPromptCards(),
                    const Spacer(flex: 2),
                    const _LoadingPill(),
                    SizedBox(height: 28.h),
                    Text(
                      '© 2024 PromptHub. All rights reserved.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedText,
                      ),
                    ),
                    SizedBox(height: 22.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PromptLogo extends StatelessWidget {
  const _PromptLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7D8BFF), AppColors.primary],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 28.r,
            offset: Offset(0, 14.h),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'P',
          style: TextStyle(
            color: Colors.white,
            fontSize: 42.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _FloatingPromptCards extends StatelessWidget {
  const _FloatingPromptCards();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 10.w,
            bottom: 32.h,
            child: const _PromptTile(angle: -0.27, label: 'Prompt'),
          ),
          Positioned(
            right: 18.w,
            bottom: 14.h,
            child: const _PromptTile(angle: 0.28, label: 'Workflow'),
          ),
          Positioned(
            top: 22.h,
            child: const _PromptTile(angle: 0.08, label: 'Skill'),
          ),
        ],
      ),
    );
  }
}

class _PromptTile extends StatelessWidget {
  const _PromptTile({required this.angle, required this.label});

  final double angle;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle * math.pi,
      child: Container(
        width: 118.w,
        height: 82.h,
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.18),
              blurRadius: 26.r,
              offset: Offset(0, 14.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Container(
              width: 26.w,
              height: 26.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 16,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingPill extends StatelessWidget {
  const _LoadingPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72.w,
      height: 5.h,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AppColors.line,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: FractionallySizedBox(
        widthFactor: 0.48,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(999.r),
          ),
        ),
      ),
    );
  }
}
