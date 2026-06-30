import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutterdevscaffold/app/common/app_theme.dart';
import 'package:flutterdevscaffold/app/http/token_manager.dart';
import 'package:flutterdevscaffold/app/router/app_router.dart';

final mainTabProvider = StateProvider<int>((ref) => 0);

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(mainTabProvider);

    return Scaffold(
      body: IndexedStack(
        index: tabIndex,
        children: const [
          _PromptHomeView(),
          _SkillHomeView(),
          _ProfileHomeView(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 68,
        selectedIndex: tabIndex,
        onDestinationSelected: (index) {
          ref.read(mainTabProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome_rounded),
            label: 'Prompt',
          ),
          NavigationDestination(
            icon: Icon(Icons.extension_outlined),
            selectedIcon: Icon(Icons.extension_rounded),
            label: 'Skill',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: '我的',
          ),
        ],
      ),
    );
  }
}

class _PromptHomeView extends StatelessWidget {
  const _PromptHomeView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _HomeHeader(),
                  SizedBox(height: 18),
                  _SearchBox(),
                  SizedBox(height: 18),
                  _QuickStats(),
                  SizedBox(height: 22),
                  _SectionHeader(title: '精选 Prompt', action: '查看全部'),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList.list(
              children: const [
                _PromptCard(
                  title: '产品需求拆解助手',
                  description: '把 PRD 快速拆成可执行任务，覆盖边界、依赖与风险。',
                  tag: '项目管理',
                  icon: Icons.account_tree_rounded,
                ),
                SizedBox(height: 12),
                _PromptCard(
                  title: 'Flutter UI 走查专家',
                  description: '对齐设计稿、检查响应式布局和组件复用规范。',
                  tag: '客户端',
                  icon: Icons.phone_iphone_rounded,
                ),
                SizedBox(height: 12),
                _PromptCard(
                  title: '接口联调异常分析',
                  description: '根据请求、响应和日志定位联调阶段的问题。',
                  tag: '联调',
                  icon: Icons.hub_rounded,
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillHomeView extends StatelessWidget {
  const _SkillHomeView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: const [
          _SimpleTitle(title: 'Skill 管理'),
          SizedBox(height: 18),
          _SearchBox(hint: '搜索 Skill、标签或工作流'),
          SizedBox(height: 18),
          _SkillTile(
            title: '需求分析 Skill',
            subtitle: '12 个 Prompt · 最近更新 2 小时前',
            status: '已启用',
            icon: Icons.psychology_rounded,
          ),
          SizedBox(height: 12),
          _SkillTile(
            title: '代码审查 Skill',
            subtitle: '8 个 Prompt · 适用于 Flutter / Web',
            status: '草稿',
            icon: Icons.rate_review_rounded,
          ),
          SizedBox(height: 12),
          _SkillTile(
            title: '发布检查 Skill',
            subtitle: '5 个 Prompt · 覆盖灰度、回滚和验收',
            status: '已启用',
            icon: Icons.rocket_launch_rounded,
          ),
        ],
      ),
    );
  }
}

class _ProfileHomeView extends StatelessWidget {
  const _ProfileHomeView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const _SimpleTitle(title: '我的'),
          const SizedBox(height: 18),
          const _ProfileCard(),
          const SizedBox(height: 18),
          const _SettingTile(icon: Icons.cloud_done_rounded, title: '同步状态'),
          const _SettingTile(icon: Icons.security_rounded, title: '账号与安全'),
          const _SettingTile(icon: Icons.tune_rounded, title: '偏好设置'),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () async {
              await TokenManager.clear();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('退出登录'),
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFF7D8BFF), AppColors.primary],
            ),
          ),
          child: const Center(
            child: Text(
              'P',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PromptHub', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(
                '今天想让 AI 帮你完成什么？',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: '通知',
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({this.hint = '搜索 Prompt、Skill 或工作流'});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search_rounded, color: AppColors.mutedText),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              hint,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.mutedText,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatTile(
            label: '我的 Prompt',
            value: '128',
            icon: Icons.article_rounded,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            label: 'Skill',
            value: '18',
            icon: Icons.extension_rounded,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            label: '本周调用',
            value: '4.2k',
            icon: Icons.bolt_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                ),
          ),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        TextButton(onPressed: () {}, child: Text(action)),
      ],
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({
    required this.title,
    required this.description,
    required this.tag,
    required this.icon,
  });

  final String title;
  final String description;
  final String tag;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    _Tag(label: tag),
                  ],
                ),
                const SizedBox(height: 8),
                Text(description, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SimpleTitle extends StatelessWidget {
  const _SimpleTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }
}

class _SkillTile extends StatelessWidget {
  const _SkillTile({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String status;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 5),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          _Tag(label: status),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PromptHub 用户',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  '已开启云端同步',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.mutedText),
        ],
      ),
    );
  }
}
