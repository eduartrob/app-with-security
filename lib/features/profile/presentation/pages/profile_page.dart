import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/secure_data_service.dart';
import '../../../../core/services/user_profile_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _bankController;
  late TextEditingController _pinController;
  late TextEditingController _cryptoController;
  late TextEditingController _medicalController;
  
  bool _obscurePin = true;
  bool _isLoading = false;
  String? _currentBase64Image;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _bankController = TextEditingController();
    _pinController = TextEditingController();
    _cryptoController = TextEditingController();
    _medicalController = TextEditingController();

    // Cargar datos actuales si existen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final secureData = context.read<SecureDataService>().currentData;
      final userProfile = context.read<UserProfileService>();
      
      if (secureData.isNotEmpty) {
        setState(() {
          _bankController.text = secureData['Cuenta Bancaria'] ?? '';
          _pinController.text = secureData['PIN de Tarjeta'] ?? '';
          _cryptoController.text = secureData['Llave Crypto'] ?? '';
          _medicalController.text = secureData['ID Historial Médico'] ?? '';
        });
      }
      
      setState(() {
        _nameController.text = userProfile.userName;
        _currentBase64Image = userProfile.profileImageBase64;
      });
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _currentBase64Image = base64Encode(bytes);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bankController.dispose();
    _pinController.dispose();
    _cryptoController.dispose();
    _medicalController.dispose();
    super.dispose();
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    await context.read<UserProfileService>().saveProfile(
      name: _nameController.text,
      imageBase64: _currentBase64Image,
    );
    
    await context.read<SecureDataService>().saveData(
      bankAccount: _bankController.text,
      pin: _pinController.text,
      cryptoKey: _cryptoController.text,
      medicalId: _medicalController.text,
    );
    
    setState(() => _isLoading = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Datos de la bóveda guardados con éxito'),
          backgroundColor: Color(0xFF4C6455),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color bgBackground = Color(0xFFF9F9F9);
    const Color textPrimary = Color(0xFF4C6455);

    return Scaffold(
      backgroundColor: bgBackground,
      appBar: AppBar(
        backgroundColor: bgBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: textPrimary),
        title: const Text(
          'Mi Perfil',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: textPrimary.withOpacity(0.2), width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: _currentBase64Image != null 
                                ? MemoryImage(base64Decode(_currentBase64Image!)) 
                                : const NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=256&h=256&q=80') as ImageProvider,
                            child: _currentBase64Image == null ? const Icon(Icons.person, size: 40, color: Colors.white) : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: textPrimary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Form Fields
                _buildTextField(
                  controller: _nameController,
                  label: 'Nombre Completo',
                  icon: Icons.person,
                  hint: 'Tu nombre',
                ),
                const SizedBox(height: 16),
                
                const Divider(),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Configuración de Bóveda Segura',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'Tus datos sensibles están encriptados',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Form Fields
                _buildTextField(
                  controller: _bankController,
                  label: 'Cuenta Bancaria',
                  icon: Icons.account_balance,
                  hint: 'Ej: MX-9876-5432...',
                ),
                const SizedBox(height: 16),
                
                _buildTextField(
                  controller: _pinController,
                  label: 'PIN de Tarjeta',
                  icon: Icons.password,
                  hint: '****',
                  obscureText: _obscurePin,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePin ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePin = !_obscurePin;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildTextField(
                  controller: _cryptoController,
                  label: 'Llave Crypto',
                  icon: Icons.currency_bitcoin,
                  hint: '0xabc123...',
                ),
                const SizedBox(height: 16),
                
                _buildTextField(
                  controller: _medicalController,
                  label: 'ID Historial Médico',
                  icon: Icons.medical_information,
                  hint: 'MED-2026...',
                ),
                const SizedBox(height: 48),
                
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: textPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Guardar Datos',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF4C6455)),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF4C6455), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
