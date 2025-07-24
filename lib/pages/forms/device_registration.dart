import 'package:flutter/material.dart';
import 'package:gsec/models/device.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/device_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DeviceRegistrationPage extends StatefulWidget {
  const DeviceRegistrationPage({super.key});

  @override
  State<DeviceRegistrationPage> createState() => _DeviceRegistrationPageState();
}

class _DeviceRegistrationPageState extends State<DeviceRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _serialController = TextEditingController();
  final _imeiController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _purchaseLocationController = TextEditingController();
  final _priceController = TextEditingController();

  EntityType _selectedType = EntityType.mobile;
  DateTime? _purchaseDate;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _serialController.dispose();
    _imeiController.dispose();
    _descriptionController.dispose();
    _purchaseLocationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Device'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer2<Auth, DeviceProvider>(
        builder: (context, auth, deviceProvider, child) {
          if (auth.currentUser == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Please sign in to register devices',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionHeader('Basic Information'),
                  _buildTextField(
                    controller: _nameController,
                    label: 'Device Name',
                    hint: 'e.g., My iPhone 14',
                    icon: Icons.devices,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a device name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _brandController,
                          label: 'Brand',
                          hint: 'e.g., Apple, Samsung',
                          icon: Icons.business,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _modelController,
                          label: 'Model',
                          hint: 'e.g., iPhone 14 Pro',
                          icon: Icons.phone_android,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Technical Details'),
                  _buildTextField(
                    controller: _serialController,
                    label: 'Serial Number',
                    hint: 'Device serial number',
                    icon: Icons.tag,
                  ),
                  const SizedBox(height: 16),
                  if (_selectedType == EntityType.mobile) ...[
                    _buildTextField(
                      controller: _imeiController,
                      label: 'IMEI Number',
                      hint: 'IMEI for mobile devices',
                      icon: Icons.perm_device_information,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                  ],
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description (Optional)',
                    hint: 'Additional details about the device',
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Purchase Information'),
                  _buildDatePicker(),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _purchaseLocationController,
                    label: 'Purchase Location (Optional)',
                    hint: 'e.g., Apple Store, Amazon',
                    icon: Icons.store,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _priceController,
                    label: 'Purchase Price (Optional)',
                    hint: 'e.g., 999.99',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Device Photo'),
                  _buildImagePicker(),
                  const SizedBox(height: 32),
                  _buildRegisterButton(auth, deviceProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.purple, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<EntityType>(
      value: _selectedType,
      decoration: InputDecoration(
        labelText: 'Device Type',
        prefixIcon: const Icon(Icons.category),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.purple, width: 2),
        ),
      ),
      items: EntityType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type.displayName),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedType = value;
          });
        }
      },
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _purchaseDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          setState(() {
            _purchaseDate = date;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Purchase Date (Optional)',
          prefixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.purple, width: 2),
          ),
        ),
        child: Text(
          _purchaseDate != null
              ? '${_purchaseDate!.day}/${_purchaseDate!.month}/${_purchaseDate!.year}'
              : 'Select purchase date',
          style: TextStyle(
            color: _purchaseDate != null ? Colors.black : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _selectedImage != null
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _selectedImage!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                    ),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.camera_alt, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Add Device Photo'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera),
                      label: const Text('Camera'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildRegisterButton(Auth auth, DeviceProvider deviceProvider) {
    final isLoading = deviceProvider.isLoading;

    return ElevatedButton(
      onPressed: isLoading ? null : () => _registerDevice(auth, deviceProvider),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Register Device',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _registerDevice(Auth auth, DeviceProvider deviceProvider) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final device = Device(
      identifier: Device.generateIdentifier(),
      ownerId: auth.currentUser!.id,
      name: _nameController.text.trim(),
      type: _selectedType.name,
      brand: _brandController.text.trim().isNotEmpty 
          ? _brandController.text.trim() 
          : null,
      model: _modelController.text.trim().isNotEmpty 
          ? _modelController.text.trim() 
          : null,
      serialNumber: _serialController.text.trim().isNotEmpty 
          ? _serialController.text.trim() 
          : null,
      imei: _imeiController.text.trim().isNotEmpty 
          ? _imeiController.text.trim() 
          : null,
      description: _descriptionController.text.trim().isNotEmpty 
          ? _descriptionController.text.trim() 
          : null,
      purchaseDate: _purchaseDate,
      purchaseLocation: _purchaseLocationController.text.trim().isNotEmpty 
          ? _purchaseLocationController.text.trim() 
          : null,
      purchasePrice: _priceController.text.trim().isNotEmpty 
          ? double.tryParse(_priceController.text.trim()) 
          : null,
    );

    final success = await deviceProvider.addDevice(device, url: null);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Device registered successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }
}