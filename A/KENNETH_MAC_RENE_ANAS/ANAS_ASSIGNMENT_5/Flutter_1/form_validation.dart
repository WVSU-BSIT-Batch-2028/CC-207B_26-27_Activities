// 5.2 Forms with validation: a Student Registration form.
// Uses Form + GlobalKey<FormState>, TextFormField validators,
// autovalidateMode, DropdownButtonFormField, a checkbox FormField,
// and validate() / save() / reset().

import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: RegistrationFormDemo()));

const List<String> yearLevels = ['1st Year', '2nd Year', '3rd Year', '4th Year'];

class RegistrationFormDemo extends StatefulWidget {
  const RegistrationFormDemo({super.key});

  @override
  State<RegistrationFormDemo> createState() => _RegistrationFormDemoState();
}

class _RegistrationFormDemoState extends State<RegistrationFormDemo> {
  // The key gives us access to the Form's state: validate(), save(), reset()
  final _formKey = GlobalKey<FormState>();

  // Filled in by each field's onSaved when we call save()
  String _name = '';
  String _email = '';
  String? _yearLevel;

  void _submit() {
    // validate() runs every field's validator and shows error messages.
    // It returns true only when ALL validators return null.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // calls every onSaved
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registered $_name ($_email), $_yearLevel')),
      );
    }
  }

  void _reset() {
    _formKey.currentState!.reset(); // back to each field's initialValue
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Registration')),
      body: Form(
        key: _formKey,
        // Show errors as soon as the user starts editing a field
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ---- Required text ----
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person),
              ),
              textCapitalization: TextCapitalization.words,
              // A validator returns an error message, or null if valid.
              // The value is String? (it can be null), so check for that.
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              onSaved: (String? value) => _name = value!.trim(),
            ),
            const SizedBox(height: 16),

            // ---- Email format ----
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'you@wvsu.edu.ph',
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Email is required';
                final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                if (!emailPattern.hasMatch(value)) return 'Invalid email format';
                return null;
              },
              onSaved: (value) => _email = value!,
            ),
            const SizedBox(height: 16),

            // ---- Password with length rule ----
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              validator: (value) => (value == null || value.length < 8)
                  ? 'Password must be at least 8 characters'
                  : null,
            ),
            const SizedBox(height: 16),

            // ---- Dropdown inside a form ----
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Year level',
                prefixIcon: Icon(Icons.school),
              ),
              items: [
                for (final level in yearLevels)
                  DropdownMenuItem(value: level, child: Text(level)),
              ],
              onChanged: (value) {}, // value is stored by onSaved below
              validator: (value) =>
                  value == null ? 'Please choose your year level' : null,
              onSaved: (value) => _yearLevel = value,
            ),
            const SizedBox(height: 16),

            // ---- Any widget can join a Form with FormField<T> ----
            FormField<bool>(
              initialValue: false,
              validator: (agreed) =>
                  agreed == true ? null : 'You must accept the terms',
              builder: (FormFieldState<bool> field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('I agree to the terms and conditions'),
                      value: field.value ?? false,
                      onChanged: field.didChange, // updates the field's value
                    ),
                    if (field.hasError)
                      Text(
                        field.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _submit,
                    child: const Text('Register'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
