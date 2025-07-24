import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/pages/authentication/registration.dart';
import 'package:gsec/pages/page.dart';
import 'package:gsec/widgets/nm_box.dart';

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
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,

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
                            // decoration: TextDecoration.lineThrough,
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
                  SizedBox(
                    height: 30,
                  ),
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
                  _buildLoginButton(context),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password functionality
                    },
                    child: const Text(
                      "Forgot your password?",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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

  Widget _buildLoginButton(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: nMbox.copyWith(boxShadow: const []),
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement login functionality
          _handleLogin(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.purpleAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
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

  void _handleLogin(BuildContext context) {
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
    
    // TODO: Implement actual authentication
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login functionality will be implemented'),
      ),
    );
  }

  Container _buildTextField(hint, controller, icon) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: nMbox.copyWith(color: Colors.white),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon),
          ),
          alignLabelWithHint: true,
          border: OutlineInputBorder(borderSide: BorderSide.none),
          hintText: hint,
        ),
      ),
    );
  }
}
