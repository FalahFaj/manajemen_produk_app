import 'package:flutter/material.dart';

import '../services/api_service.dart';

class SubmitPage extends StatefulWidget {
  final String token;

  const SubmitPage({
    super.key,
    required this.token,
  });

  @override
  State<SubmitPage> createState() =>
      _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final githubController = TextEditingController();

  bool isLoading = false;

  Future<void> submit() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        githubController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua bidang')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final success = await ApiService.submitTugas(
        widget.token,
        nameController.text,
        int.parse(priceController.text),
        descriptionController.text,
        githubController.text,
      );

      setState(() => isLoading = false);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil submit tugas')),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal submit tugas')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'PBM Tugas API',
          style: TextStyle(
            color: Color(0xFF1E56C1),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Submit Tugas\nPraktikum',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Lengkapi form di bawah ini untuk mengirimkan\nhasil pekerjaan Anda.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            
            _buildFieldLabel('Nama Produk'),
            _buildTextField(
              controller: nameController,
              hint: 'Masukkan nama produk',
              icon: Icons.inventory_2_outlined,
            ),
            
            const SizedBox(height: 20),
            
            _buildFieldLabel('Harga'),
            _buildTextField(
              controller: priceController,
              hint: 'Masukkan harga',
              icon: Icons.account_balance_wallet_outlined,
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: 20),
            
            _buildFieldLabel('Deskripsi'),
            _buildTextField(
              controller: descriptionController,
              hint: 'Masukkan deskripsi produk',
              icon: Icons.description_outlined,
              maxLines: 4,
            ),
            
            const SizedBox(height: 20),
            
            _buildFieldLabel('URL Repository GitHub'),
            _buildTextField(
              controller: githubController,
              hint: 'https://github.com/username/repo',
              icon: Icons.link,
            ),
            
            const SizedBox(height: 40),
            
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: isLoading ? null : submit,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E56C1),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E56C1).withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLoading)
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      else ...[
                        const Icon(Icons.send, color: Colors.white, size: 18),
                        const SizedBox(width: 10),
                        const Text(
                          'Submit Tugas',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 1,
          onTap: (index) {
            if (index == 0) {
              Navigator.pop(context);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1E56C1),
          unselectedItemColor: Colors.black38,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.send_outlined),
              label: 'Submit',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3142),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(bottom: maxLines > 1 ? 60 : 0),
            child: Icon(icon, size: 20, color: Colors.black38),
          ),
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.black26),
          filled: true,
          fillColor: const Color(0xFFFBFBFF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
    );
  }
}