import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/services/api_client.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/market_repository.dart';

// Core Dependencies
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(secureStorage);
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(apiClient);
});

final marketRepositoryProvider = Provider<MarketRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MarketRepository(apiClient);
});

// Authentication State
final authStateProvider = StateProvider<bool>((ref) => false);

/// Theme mode provider
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// Price color mode provider (Red Up/Green Down vs Green Up/Red Down)
final priceColorModeProvider = StateProvider<bool>((ref) {
  // true = red up/green down (China style)
  // false = green up/red down (Western style)
  return true;
});

/// Language provider
final languageProvider = StateProvider<String>((ref) => 'zh');

/// Current navigation index provider (for bottom nav)
final currentIndexProvider = StateProvider<int>((ref) => 0);
