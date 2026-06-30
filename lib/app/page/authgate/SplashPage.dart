import 'dart:math' as math;

import 'package:flutter/material.dart';
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
              constraints: const BoxConstraints(maxWidth: 430),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    const _PromptLogo(size: 72),
                    const SizedBox(height: 18),
                    Text(
                      'PromptHub',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '让 AI 更懂你，让创意更高效',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    const _FloatingPromptCards(),
                    const Spacer(flex: 2),
                    const _LoadingPill(),
                    const SizedBox(height: 28),
                    Text(
                      '© 2024 PromptHub. All rights reserved.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.mutedText,
                          ),
                    ),
                    const SizedBox(height: 22),
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
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7D8BFF), AppColors.primary],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'P',
          style: TextStyle(
            color: Colors.white,
            fontSize: 42,
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
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: const [
          Positioned(
            left: 10,
            bottom: 32,
            child: _PromptTile(angle: -0.27, label: 'Prompt'),
          ),
          Positioned(
            right: 18,
            bottom: 14,
            child: _PromptTile(angle: 0.28, label: 'Workflow'),
          ),
          Positioned(
            top: 22,
            child: _PromptTile(angle: 0.08, label: 'Skill'),
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
        width: 118,
        height: 82,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.18),
              blurRadius: 26,
              offset: const Offset(0, 14),
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
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(8),
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
      width: 72,
      height: 5,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AppColors.line,
        borderRadius: BorderRadius.circular(999),
      ),
      child: FractionallySizedBox(
        widthFactor: 0.48,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}
