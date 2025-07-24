import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/pages/authentication/registration.dart';
import 'package:gsec/pages/page.dart';
import 'package:gsec/widgets/nm_box.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const TextStyle defaultStyle = TextStyle(
      fontSize: 40, 
      color: Colors.white, 
      fontWeight: FontWeight.w100,
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/back.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.black.withOpacity(.5), 
                  Colors.black.withOpacity(.8),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: ListView(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: "Welcome to\n",
                      children: [
                        TextSpan(
                          text: "Gadget Security\n",
                          style: defaultStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
                        TextSpan(
                          text: "Your global device database",
                          style: defaultStyle.copyWith(
                            fontSize: 25,
                          ),
                        )
                      ],
                      style: defaultStyle,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: <Widget>[
                      Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          controller: _emailController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(FontAwesomeIcons.userAlt, color: Colors.white70),
                            border: InputBorder.none,
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          controller: _passController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          obscureText: true,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(FontAwesomeIcons.lock, color: Colors.white70),
                            border: InputBorder.none,
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Consumer<Auth>(
                    builder: (context, auth, child) {
                      return _buildLoginButton(context, auth);
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      _showForgotPasswordDialog(context);
                    },
                    child: const Text(
                      "Forgot your password?",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const Text(
                        "Your first time here?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          var route = animateRoute(
                            context: context,
                            page: SignUp(),
                          );
                          Navigator.push(context, route);
                        },
                        child: const Text(
                          "Join Us",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, Auth auth) {
    final bool isLoading = auth.state == AuthState.loading;
    
    return Container(
      alignment: Alignment.center,
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: nMbox.copyWith(boxShadow: const []),
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _handleLogin(context, auth),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.purpleAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading 
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text(
              'Sign In',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.purpleAccent,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context, Auth auth) async {
    final email = _emailController.text.trim();
    final password = _passController.text.trim();
    
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final success = await auth.signInWithEmail(email, password);
    
    if (success) {
      // Navigate to main app or dashboard
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email address to receive a password reset link.'),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Consumer<Auth>(
            builder: (context, auth, child) {
              return ElevatedButton(
                onPressed: auth.state == AuthState.loading 
                  ? null 
                  : () async {
                      final email = emailController.text.trim();
                      if (email.isNotEmpty && _isValidEmail(email)) {
                        final result = await auth.resetPassword(email);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a valid email address'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                child: auth.state == AuthState.loading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Send Reset Link'),
              );
            },
          ),
        ],
      ),
    );
  }

  Container _buildTextField(hint, controller, icon) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: nMbox.copyWith(color: Colors.white),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon),
          ),
          alignLabelWithHint: true,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          hintText: hint,
        ),
      ),
    );
  }
}
