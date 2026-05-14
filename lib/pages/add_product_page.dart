import 'package:flutter/material.dart';

import '../services/api_service.dart';

class AddProductPage extends StatefulWidget {
  final String token;

  const AddProductPage({
    super.key,
    required this.token,
  });

  @override
  State<AddProductPage> createState() =>
      _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isLoading = false;

  Future<void> saveProduct() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua bidang')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final success = await ApiService.addProduct(
        widget.token,
        nameController.text,
        priceController.text,
        descriptionController.text,
      );

      setState(() => isLoading = false);

      if (success && mounted) {
        // Show Success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D3142),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 20),
                  SizedBox(width: 12),
                  Text(
                    'Produk berhasil ditambahkan',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
        
        // Wait a bit before popping
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) Navigator.pop(context);
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menambahkan produk')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Produk Baru',
          style: TextStyle(
            color: Color(0xFF2D3142),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nama Produk',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.inventory_2_outlined, size: 22),
                hintText: 'Masukkan nama produk...',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.black26),
                filled: true,
                fillColor: const Color(0xFFFBFBFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Harga',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.account_balance_wallet_outlined, size: 22),
                hintText: 'Rp 0',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.black26),
                filled: true,
                fillColor: const Color(0xFFFBFBFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Deskripsi',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 80),
                  child: Icon(Icons.description_outlined, size: 22),
                ),
                hintText: 'Jelaskan detail produk secara singkat...',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.black26),
                filled: true,
                fillColor: const Color(0xFFFBFBFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
            const SizedBox(height: 80),
            GestureDetector(
              onTap: isLoading ? null : saveProduct,
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0052D4),
                      Color(0xFF4364F7),
                      Color(0xFF6FB1FC),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0052D4).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Simpan Produk',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}