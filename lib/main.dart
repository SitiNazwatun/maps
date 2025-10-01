import 'package:flutter/material.dart';
import 'package:maps/bloc/map/map_bloc.dart';
import 'package:maps/repositorie/map_repo.dart';
import 'view/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'view/beranda.dart';
import '../view/maps.dart';
import 'repositorie/auth_repo.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/auth/auth_state.dart';

import 'repositorie/map_repo.dart';
import 'bloc/map/map_bloc.dart';
import 'bloc/map/map_event.dart';
import 'bloc/map/map_state.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Nyediain repository, pakai multi soalnya biar bisa nampung lebih dari 1
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthRepo>(
            create: (context) => AuthRepo(),
          ),
          RepositoryProvider<MapRepo>(
            create: (context) => MapRepo(),
          ),
        ],
      // Nyediain bloc, pakai multi supaya bisa lebih dari 1
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
              create: (context) {
                final authRepo = context.read<AuthRepo>(); //kunci injection. AuthBloc ambil AuthRepo dari context yg diatas
                return AuthBloc(authRepo)..add(cekAutoLogin()); //memicu event cekAutoLogin
              },
          ),
          BlocProvider<MapBloc>(
            create: (context) {
              final mapRepo = context.read<MapRepo>();
              return MapBloc(mapRepo);
            },
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My App',
          theme: ThemeData(
              primarySwatch: Colors.blue
          ),
          home: const AuthWrapper(),
        ),
      ),
    );
  }
  }

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocBuilder akan mendengarkan perubahan state dari AuthBloc
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          // Tampilkan loading screen saat sedang cek token
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthSuccess) {
          // Navigasi ke Beranda jika login berhasil
          return const HomePage();
        } else {
          // Navigasi ke halaman Login jika belum ada token atau gagal
          return const LoginPage();
        }
      },
    );
  }
}
