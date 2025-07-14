import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Widget aman‑lintas‑platform (Web / Mobile / Desktop) untuk menampilkan
/// gambar lokal **atau** gambar dari URL.
/// – Jika `networkUrl` tersedia → pakai `Image.network`.
/// – Jika **bukan** web & `filePath` tersedia → `Image.file`.
/// – Jika keduanya null / kosong → kotak abu‑abu + ikon.
class AppImage extends StatelessWidget {
  final String? filePath;      // path di device
  final String? networkUrl;    // url Firebase Storage dsb.
  final double? width;
  final double? height;
  final BorderRadius? radius;

  const AppImage({
    super.key,
    this.filePath,
    this.networkUrl,
    this.width,
    this.height,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (networkUrl != null && networkUrl!.isNotEmpty) {
      child = Image.network(
        networkUrl!,
        width : width,
        height: height,
        fit   : BoxFit.cover,
      );
    } else if (!kIsWeb && filePath != null && filePath!.isNotEmpty) {
      child = Image.file(
        File(filePath!),
        width : width,
        height: height,
        fit   : BoxFit.cover,
      );
    } else {
      child = Container(
        width : width,
        height: height,
        color : Colors.grey.shade300,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported),
      );
    }

    return radius == null
        ? child
        : ClipRRect(borderRadius: radius!, child: child);
  }
}
