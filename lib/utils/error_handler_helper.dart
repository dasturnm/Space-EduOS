import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ErrorHandlerHelper {
  /// Menguraikan galat Supabase/Postgrest/Auth menjadi pesan yang mudah dipahami
  static String parseError(dynamic error) {
    if (error is PostgrestException) {
      return "Gagal melakukan operasi basis data: ${error.message} (Kode: ${error.code})";
    }
    if (error is AuthException) {
      return "Masalah otorisasi/login: ${error.message}";
    }
    return "Terjadi kesalahan tidak terduga: ${error.toString()}";
  }

  /// Menampilkan SnackBar galat seragam di seluruh layar UI
  static void showSnackBarError(BuildContext context, dynamic error) {
    final String cleanMessage = parseError(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(cleanMessage),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}