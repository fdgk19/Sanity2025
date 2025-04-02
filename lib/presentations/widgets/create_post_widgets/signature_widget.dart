import 'package:flutter/material.dart';

class SignatureItem extends StatelessWidget {
  const SignatureItem({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController signatureController = TextEditingController();
    return TextField(
      controller: signatureController,
      style: const TextStyle(fontFamily: 'Signatrue', fontSize: 30),
    );
  }
}