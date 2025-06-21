import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';

class PasswordWithConfirmField extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const PasswordWithConfirmField({
    Key? key,
    required this.passwordController,
    required this.confirmPasswordController,
  }) : super(key: key);

  @override
  _PasswordWithConfirmFieldState createState() =>
      _PasswordWithConfirmFieldState();
}

class _PasswordWithConfirmFieldState extends State<PasswordWithConfirmField> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _matchError;

  List<String> passwordHints = [];
  int passwordStrength = 0;

  List<String> getPasswordErrors(String password) {
    List<String> errors = [];
    passwordStrength = 0;

    if (password.length >= 8) {
      errors.add("✅ At least 8 characters");
      passwordStrength++;
    } else {
      errors.add("❌ At least 8 characters");
    }

    if (RegExp(r'[A-Z]').hasMatch(password)) {
      errors.add("✅ Has uppercase letter");
      passwordStrength++;
    } else {
      errors.add("❌ At least one uppercase letter");
    }

    if (RegExp(r'[a-z]').hasMatch(password)) {
      errors.add("✅ Has lowercase letter");
      passwordStrength++;
    } else {
      errors.add("❌ At least one lowercase letter");
    }

    if (RegExp(r'\d').hasMatch(password)) {
      errors.add("✅ Has number");
      passwordStrength++;
    } else {
      errors.add("❌ At least one number");
    }

    if (RegExp(r'[!@#\$&*~]').hasMatch(password)) {
      errors.add("✅ Has special character");
      passwordStrength++;
    } else {
      errors.add("❌ At least one special character (!@#\$&*~)");
    }

    return errors;
  }

  void checkMatch() {
    if (widget.confirmPasswordController.text.isEmpty) {
      // لو لسه مش كتب في تأكيد الباسورد ما تظهرش أي رسالة
      setState(() {
        _matchError = null;
      });
    } else if (widget.passwordController.text ==
        widget.confirmPasswordController.text) {
      setState(() {
        _matchError = 'match'; // هنا بنخزن انه فيه ماتش
      });
    } else {
      setState(() {
        _matchError = "Passwords do not match";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Password Field
        TextFormField(
          controller: widget.passwordController,
          obscureText: _obscurePassword,
          onChanged: (value) {
            setState(() {
              passwordHints = getPasswordErrors(value);
            });
            checkMatch();
          },
          decoration: InputDecoration(
            hintText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),

        const SizedBox(height: 8),

        if (widget.passwordController.text.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: passwordStrength / 5,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                passwordStrength <= 2
                    ? AppColors.red
                    : passwordStrength == 3 || passwordStrength == 4
                        ? Colors.orange
                        : Colors.green,
              ),
            ),
          ),

        if (passwordHints.isNotEmpty) const SizedBox(height: 12),

        if (passwordHints.isNotEmpty)
          Card(
            elevation: 2,
            color: Colors.grey.shade200,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: passwordHints.map((hint) {
                  final isValid = hint.startsWith("✅");
                  return Row(
                    children: [
                      Icon(isValid ? Icons.check_circle : Icons.cancel,
                          size: 18,
                          color: isValid ? Colors.green : AppColors.red),
                      const SizedBox(width: 8),
                      Text(
                        hint.replaceFirst("✅ ", "").replaceFirst("❌ ", ""),
                        style: TextStyle(
                            color: isValid ? Colors.green : AppColors.red,
                            fontSize: 13),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),

        const SizedBox(height: 16),

        // Confirm Password Field
        TextFormField(
          controller: widget.confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          onChanged: (value) {
            checkMatch();
          },
          decoration: InputDecoration(
            hintText: 'Confirm Password',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword
                  ? Icons.visibility_off
                  : Icons.visibility),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            errorText: _matchError != null && _matchError != 'match'
                ? _matchError
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        if (_matchError == 'match')
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                const Text(
                  'Passwords match',
                  style: TextStyle(color: Colors.green, fontSize: 13),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
