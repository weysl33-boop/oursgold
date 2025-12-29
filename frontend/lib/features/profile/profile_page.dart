import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/providers.dart';

/// Profile page - User settings and preferences
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final language = ref.watch(languageProvider);
    final priceColorMode = ref.watch(priceColorModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          const CircleAvatar(
            radius: 40,
            child: Icon(Icons.person, size: 40),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              '未登录',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('深色模式'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).state =
                    value ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('语言'),
            trailing: Text(language == 'zh' ? '中文' : 'English'),
            onTap: () {
              ref.read(languageProvider.notifier).state =
                  language == 'zh' ? 'en' : 'zh';
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('价格颜色'),
            trailing: Text(priceColorMode ? '红涨绿跌' : '绿涨红跌'),
            onTap: () {
              ref.read(priceColorModeProvider.notifier).state = !priceColorMode;
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('设置'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('关于'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
