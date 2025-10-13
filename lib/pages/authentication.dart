import 'dart:async';

import 'package:flutter/material.dart';
import 'package:greenly/main.dart';
import 'package:greenly/pages/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

/// authentication.dart - Provides UI/UX for user authentication
///
class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<StatefulWidget> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    const scrollViewEdgeInsets = EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 12,
    );

    // padding: scrollViewEdgeInsets,
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.directional(top: 50),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                tabs: <Widget>[
                  Tab(icon: Icon(Icons.login)),
                  Tab(icon: Icon(Icons.account_circle_outlined)),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: scrollViewEdgeInsets,
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(child: _LoginCard()),
                      SingleChildScrollView(child: _NewAccountCard()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewAccountCard extends StatefulWidget {
  const _NewAccountCard();

  @override
  State<_NewAccountCard> createState() => _NewAccountCardState();
}

class _NewAccountCardState extends State<_NewAccountCard> {
  final _formKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _passwordChoice = TextEditingController();
  final _repeatPassword = TextEditingController();

  late final StreamSubscription<AuthState> _authStateSubscription;

  bool _isLoading = false;
  bool _redirecting = false;
  bool _otpEmitted = false;

  Future _createAccount() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await supabase.auth.signUp(
        email: _email.text,
        password: _passwordChoice.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Check your email for an OTP Code!')),
        );
      }
    } on AuthException catch (err) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err.message)));
      }
    } catch (err) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error : ${err.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _otpEmitted = true;
        });
      }
    }
    // throw UnimplementedError();
  }

  Future _validateAccount(String otpCode) async {
    try {
      await supabase.auth.verifyOTP(
        type: OtpType.signup,
        email: _email.text,
        token: otpCode.trim(),
      );
    } on AuthException catch (err) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Try again later...')));

      debugPrint('Got an error authenticating: $err');
    } catch (err) {
      throw UnimplementedError('Unexpected authentication error, not handled');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _otpEmitted = true;
        });
      }
    }
  }

  @override
  void initState() {
    // supabase.auth.currentSession!.user.email;
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;

      final session = data.session;
      if (session != null) {
        _redirecting = true;
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();

    _email.dispose();
    _passwordChoice.dispose();
    _repeatPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = TextTheme.of(context);

    const formTitle = 'Lets get started!';
    const innerCardEdgeInsets = EdgeInsets.all(20);

    var emailInpDecoration = InputDecoration(
      contentPadding: EdgeInsetsGeometry.all(8),
      label: Text('Enter an email'),
      hintText: 'user@email.com',
      prefixIcon: Icon(Icons.email_rounded),
      filled: true,
      fillColor: Colors.white,
    );

    var passwordFormInputDecoration = InputDecoration(
      contentPadding: EdgeInsetsGeometry.all(8),
      label: Text('Password'),
      hintText: '**********',
      prefixIcon: Icon(Icons.password_rounded),
      suffixIcon: Icon(Icons.visibility_off),
      filled: true,
      fillColor: Colors.white,
    );

    var passwordRepeatFormInputDecoration = InputDecoration(
      contentPadding: EdgeInsetsGeometry.all(8),
      label: Text('Repeat the Password'),
      hintText: '**********',
      prefixIcon: Icon(Icons.password_rounded),
      suffixIcon: Icon(Icons.visibility_off),
      filled: true,
      fillColor: Colors.white,
    );

    SizedBox spacer({double? h}) => (SizedBox(height: h ?? 20.0));

    return Card(
      elevation: 1,
      shadowColor: Colors.black54,
      color: Colors.white,
      child: Padding(
        padding: innerCardEdgeInsets,
        child: Form(
          key: _formKey,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(formTitle, style: textTheme.titleLarge),
              spacer(),
              // User's Email
              TextFormField(
                controller: _email,
                decoration: emailInpDecoration,
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: true,
                spellCheckConfiguration: SpellCheckConfiguration.disabled(),
                validator: (email) {
                  if (email == null || email.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              spacer(h: 6),
              // Password choice
              TextFormField(
                controller: _passwordChoice,
                keyboardType: TextInputType.visiblePassword,
                decoration: passwordFormInputDecoration,
                enableSuggestions: false,
                spellCheckConfiguration: SpellCheckConfiguration.disabled(),
                validator: (password) {
                  if (password == null || password.isEmpty) {
                    return 'Please enter the password';
                  }
                  return null;
                },
              ),
              // Password repeat choice
              TextFormField(
                controller: _repeatPassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: passwordRepeatFormInputDecoration,
                enableSuggestions: false,
                spellCheckConfiguration: SpellCheckConfiguration.disabled(),
                validator: (password) {
                  if (password == null || password.isEmpty) {
                    return 'Please enter a password';
                  }

                  if (password != _passwordChoice.text) {
                    return 'Please enter the same password';
                  }

                  return null;
                },
              ),
              spacer(),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // ScaffoldMessenger.of(
                    //   context,
                    // ).showSnackBar(SnackBar(content: Text(_email.text)));
                    _isLoading ? null : _createAccount();
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Should not get here!')),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5,
                  children: [
                    Text(
                      _isLoading ? 'Creatting Account...' : 'Create Account',
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  if (!_otpEmitted) {
                    return SizedBox();
                  }
                  return Column(
                    children: [
                      spacer(),
                      spacer(),
                      Text('Enter your OTP code', style: textTheme.titleMedium),
                      spacer(),
                      OtpTextField(
                        numberOfFields: 6,
                        fieldWidth: 60,
                        borderColor: Color(0xFF512DA8),
                        showFieldAsBox: true,
                        onCodeChanged: (String code) {},
                        onSubmit: (String otpCode) {
                          _validateAccount(otpCode);
                        },
                      ),
                      spacer(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginCard extends StatefulWidget {
  const _LoginCard();

  @override
  State<StatefulWidget> createState() => _LoginCardState();
}

class _LoginCardState extends State<_LoginCard> {
  final _formKey = GlobalKey<FormState>();

  late final _emailController = TextEditingController();
  late final _passwordController = TextEditingController();

  late final StreamSubscription<AuthState> _authStateSubscription;

  bool _isLoading = false;
  bool _redirecting = false;

  Future<void> _signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Welcome back!!!')));
      }
    } on AuthException catch (err) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err.message)));
      }
    } catch (err) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error : ${err.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
    throw UnimplementedError();
  }

  @override
  void initState() {
    // supabase.auth.currentSession!.user.email;
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;

      final session = data.session;
      if (session != null) {
        _redirecting = true;
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = TextTheme.of(context);

    const formLoginTitle = 'Welcome!';

    const innerCardEdgeInsets = EdgeInsets.all(20);

    var emailFormInputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsetsGeometry.all(8),
      label: Text('Email'),
      hintText: 'user@email.com',
      prefixIcon: Icon(Icons.face_rounded),
      filled: true,
      fillColor: Colors.white,
    );

    var passwordFormInputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsetsGeometry.all(8),
      label: Text('Password'),
      hintText: '**********',
      prefixIcon: Icon(Icons.password_rounded),
      suffixIcon: Icon(Icons.visibility_rounded),
      filled: true,
      fillColor: Colors.white,
    );

    SizedBox spacer({double? h}) => (SizedBox(height: h ?? 20.0));

    return Card(
      elevation: 1,
      shadowColor: Colors.black54,
      color: Colors.white,
      child: Padding(
        padding: innerCardEdgeInsets,
        child: Form(
          key: _formKey,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(formLoginTitle, style: textTheme.titleLarge),
              spacer(),
              TextFormField(
                controller: _emailController,
                decoration: emailFormInputDecoration,
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: true,
                spellCheckConfiguration: SpellCheckConfiguration.disabled(),
                validator: (email) {
                  if (email == null || email.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              spacer(),
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: passwordFormInputDecoration,
                enableSuggestions: false,
                spellCheckConfiguration: SpellCheckConfiguration.disabled(),
                validator: (password) {
                  if (password == null || password.isEmpty) {
                    return 'Please enter the password';
                  }
                  return null;
                },
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot password?',
                  style: TextStyle(color: Colors.green.shade400),
                ),
              ),
              spacer(h: 10),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                    _isLoading ? null : _signIn();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5,
                  children: _isLoading
                      ? [
                          Icon(Icons.data_usage_rounded),
                          const Text('Seding...'),
                        ]
                      : [Icon(Icons.login), const Text('Login')],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
