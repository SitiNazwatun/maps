import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'beranda.dart';
import 'package:flutter_bloc/flutter_bloc.dart';    //package resmi dar BLoC untuk flutter yg isinya widget khusus buat hubungi UI sama BLoC
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) {
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      // Mengirim event LoginButtonPressed ke AuthBloc
      context.read<AuthBloc>().add(
        LoginButtonPressed(
          username: usernameController.text.trim(),
          password: passwordController.text,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Navigasi ke halaman beranda saat login berhasil dan hapus semua histroy navigasi
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false, // Kondisi untuk menghapus semua route sebelumnya
            );
          } else if (state is AuthGagal) {
            // Tampilkan SnackBar saat login gagal
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.replaceAll('Exception: ', '')),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              'galeri/bg2.png',
              fit: BoxFit.cover,
            ),

            // Overlay biar form lebih kebaca
            Container(
              color: Colors.black.withOpacity(0.2),
            ),

            // Main content
            SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                      MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 100),

                          // Welcome text
                          Text(
                            'Welcome!',
                            style: GoogleFonts.poppins(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF00016A),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Subtitle
                          Text(
                            'Sign in to continue your journey.\nEvery step you take here\nbrings you closer to\nyour goal',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF00016A),
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 50),

                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(17),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  // Email field
                                  TextFormField(
                                    controller: usernameController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: const Color(0xFF00016A),
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: GoogleFonts.poppins(

                                        fontSize: 14,
                                        color: const Color(0xFF8F90A6),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.grey),                              ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF00016A),
                                          width: 2,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 1,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 16,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Email wajib diisi';
                                      }
                                      // if (!value.contains('@')) {
                                      //   return 'Email tidak valid';
                                      // }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 23),

                                  // Password field
                                  TextFormField(
                                    controller: passwordController,
                                    obscureText: _obscurePassword,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: const Color(0xFF00016A),
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: const Color(0xFF8F90A6),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.grey),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF00016A),
                                          width: 2,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 1,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 16,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: const Color(0xFF8F90A6),
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password wajib diisi';
                                      }
                                      if (value.length < 6) {
                                        return 'Minimal 6 karakter';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 40),

                                  // Login button
                                  BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, state) {
                                      return SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: state is AuthLoading
                                              ? null
                                              : () => _handleLogin(context),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF00016A),
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: state is AuthLoading
                                              ? const CircularProgressIndicator(color: Colors.white)
                                              : Text(
                                            'Login',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          // Form

                        ],
                      ),
                    ),
                  ),
                )
            ),
          ],
        ),
      )
    );
  }
}