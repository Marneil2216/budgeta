import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

Future<void> bootstrap() async {
  assert(_supabaseUrl.isNotEmpty, 'SUPABASE_URL dart-define is required');
  assert(_supabaseAnonKey.isNotEmpty, 'SUPABASE_ANON_KEY dart-define is required');

  await Supabase.initialize(
    url: _supabaseUrl,
    anonKey: _supabaseAnonKey,
  );
  runApp(const ProviderScope(child: BudgetaApp()));
}
