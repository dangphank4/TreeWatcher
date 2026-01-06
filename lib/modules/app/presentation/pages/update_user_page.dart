import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api/core/components/confirm_dialog.dart';
import 'package:flutter_api/core/constants/app_images.dart';
import 'package:flutter_api/core/constants/app_routes.dart';
import 'package:flutter_api/core/constants/app_styles.dart';
import 'package:flutter_api/core/extensions/localized_extendsion.dart';
import 'package:flutter_api/core/extensions/num_extendsion.dart';
import 'package:flutter_api/core/helpers/navigation_helper.dart';
import 'package:flutter_api/modules/app/data/repositories/app_repository.dart';
import 'package:flutter_api/modules/app/general/app_module_routes.dart';
import 'package:flutter_modular/flutter_modular.dart';

enum Gender { male, female }

class UpdateUserPage extends StatefulWidget {
  const UpdateUserPage({super.key});

  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final avatarController = TextEditingController();
  final emailController = TextEditingController();
  String gender = '';

  Gender? _gender;

  late final AppRepository repository;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userSubscription;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    repository = Modular.get<AppRepository>();

    final user = FirebaseAuth.instance.currentUser;
    emailController.text = user?.email ?? '';

    _subscribeUser();
  }

  Future<void> _subscribeUser() async {
    setState(() {
      _loading = true;
    });

    _userSubscription = repository.subscribeUser().listen((doc) {
      if (!doc.exists || doc.data() == null) return;

      final data = doc.data()!;
      setState(() {
        nameController.text = data['fullName'] ?? '';
        phoneController.text = data['phone'] ?? '';
        avatarController.text = data['avatar'] ?? '';

        gender = data['gender'];
        if (gender == context.localization.male) {
          _gender = Gender.male;
        } else if (gender == context.localization.female) {
          _gender = Gender.female;
        }
      });
    });
    setState(() {
      _loading = false;
    });
  }

  Future<void> _saveUser() async {
    setState(() => _loading = true);

    try {
      switch (_gender) {
        case Gender.male:
          gender = context.localization.male;
          break;

        case Gender.female:
          gender = context.localization.female;
          break;

        default:
          gender = '';
      }

      await repository.updateUserProfile(
        fullName: nameController.text.trim(),
        phone: phoneController.text.trim(),
        gender: gender,
      );

      NavigationHelper.replace('${AppRoutes.moduleApp}${AppModuleRoutes.main}');
    } catch (e) {
      debugPrint('Update user error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    nameController.dispose();
    phoneController.dispose();
    avatarController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000D00),
      appBar: AppBar(
        backgroundColor: Color(0xFF001600),
        title: Title(
          color: Colors.grey,
          child: Text(
            context.localization.updateUser,
            style: Styles.h5.smb.copyWith(color: Colors.white),
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _subscribeUser,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                20.verticalSpace,
                Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: Colors.greenAccent),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        gender == context.localization.male
                            ? AppImages.maleImg
                            : AppImages.femaleImg,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                10.verticalSpace,
                _buildField(
                  controller: nameController,
                  label: context.localization.fullName,
                  hint: context.localization.enterYourFullName,
                  textColor: Colors.black,
                  hintColor: Colors.grey,
                  labelColor: Colors.green.shade300, // màu tiêu đề
                ),

                _buildField(
                  controller: emailController,
                  label: context.localization.email,
                  hint: context.localization.emailHint,
                  readOnly: true,
                  textColor: Colors.black87,
                  hintColor: Colors.grey,
                  labelColor: Colors.green.shade300,
                ),

                10.verticalSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.localization.gender,
                        style: Styles.medium.smb.copyWith(
                          color: Colors.green.shade300,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<Gender>(
                              title: Text(
                                context.localization.male,
                                style: TextStyle(color: Colors.white),
                              ),
                              value: Gender.male,
                              groupValue: _gender,
                              onChanged: (value) =>
                                  setState(() => _gender = value),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<Gender>(
                              title: Text(
                                context.localization.female,
                                style: TextStyle(color: Colors.white),
                              ),
                              value: Gender.female,
                              groupValue: _gender,
                              onChanged: (value) =>
                                  setState(() => _gender = value),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                10.verticalSpace,
                _buildField(
                  controller: phoneController,
                  label: context.localization.phoneNumber,
                  hint: context.localization.phoneHint,
                  keyboardType: TextInputType.phone,
                  textColor: Colors.black,
                  hintColor: Colors.grey,
                  labelColor: Colors.green.shade300,
                ),
                20.verticalSpace,
                TextButton(
                  onPressed: () async {
                    final confirm = await showConfirmDialog(
                      context: context,
                      title: context.localization.confirm,
                      content:
                      '${context.localization.areYouReallyWantToChangePassword}?',
                    );
                    if(confirm == true) {
                      _saveUser();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 34,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade400,
                          Colors.deepPurple.shade200,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      border: Border.all(width: 1.5, color: Colors.white),
                    ),
                    child: Text(
                      context.localization.save,
                      style: Styles.large.smb.copyWith(color: Colors.white),
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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    Color textColor = Colors.black,
    Color hintColor = Colors.grey,
    Color labelColor = Colors.black87,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: labelColor,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            maxLines: 1,
            style: TextStyle(color: textColor, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: hintColor),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
