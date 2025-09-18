import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:greenly/main.dart';
import 'package:greenly/pages/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// authentication.dart - Provides UI/UX for user authentication

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
      body: DefaultTabController(
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

  @override
  Widget build(BuildContext context) {
    var textTheme = TextTheme.of(context);

    final nameFirstAndLast = TextEditingController();
    final username = TextEditingController();
    final passwordChoice = TextEditingController();
    final repeatPassword = TextEditingController();

    @override
    void dispose() {
      nameFirstAndLast.dispose();
      super.dispose();
    }

    const formTitle = 'Lets get started!';
    const innerCardEdgeInsets = EdgeInsets.all(20);

    var userFullNameInpDecoration = InputDecoration(
      // border: (borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsetsGeometry.all(8),
      label: Text('First and last name'),
      hintText: 'John Doe',
      prefixIcon: Icon(Icons.person),
      filled: true,
      fillColor: Colors.white,
      errorText: 'Please enter your first and last name.',
    );

    var userNameInpDecoration = InputDecoration(
      // border: (borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsetsGeometry.all(8),
      label: Text('User name'),
      hintText: 'greenlyUser213',
      prefixIcon: Icon(Icons.alternate_email_rounded),
      filled: true,
      fillColor: Colors.white,
      errorText: 'Please enter a user name.',
    );

    var passwordFormInputDecoration = InputDecoration(
      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsetsGeometry.all(8),
      label: Text('Password'),
      hintText: '**********',
      prefixIcon: Icon(Icons.password_rounded),
      suffixIcon: Icon(Icons.visibility_off),
      filled: true,
      fillColor: Colors.white,
    );

    var passwordRepeatFormInputDecoration = InputDecoration(
      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsetsGeometry.all(8),
      label: Text('Repeat the Password'),
      hintText: '**********',
      prefixIcon: Icon(Icons.password_rounded),
      suffixIcon: Icon(Icons.visibility_off),
      filled: true,
      fillColor: Colors.white,
      errorText: 'Please repeat the same password',
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
              // User's name first and last
              TextFormField(
                controller: nameFirstAndLast,
                decoration: userFullNameInpDecoration,
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
              // User's user name
              TextFormField(
                controller: username,
                decoration: userNameInpDecoration,
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
              spacer(h: 6),
              // Password fields
              TextFormField(
                controller: passwordChoice,
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
              TextFormField(
                controller: repeatPassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: passwordRepeatFormInputDecoration,
                enableSuggestions: false,
                spellCheckConfiguration: SpellCheckConfiguration.disabled(),
                validator: (password) {
                  if (password == null || password.isEmpty) {
                    return 'Please enter the password';
                  }
                  return null;
                },
              ),
              spacer(),
              FilledButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(nameFirstAndLast.text)),
                    );
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5,
                  children: [Icon(Icons.add), const Text('Create Account')],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginCard extends StatefulWidget {
  const _LoginCard({super.key});

  @override
  State<StatefulWidget> createState() => _LoginCardState();
}

class _LoginCardState extends State<_LoginCard> {
  final _formKey = GlobalKey<FormState>();

  late final _emailController = TextEditingController();
  late final StreamSubscription<AuthState> _authStateSubscription;

  bool _isLoading = false;
  bool _redirecting = false;

  Future<void> _signIn() async {
    // TODO: Implement sign in
    try {
      setState(() {
        _isLoading = true;
      });

      await supabase.auth.signInWithOtp(
        email: _emailController.text.trim(),
        emailRedirectTo: kIsWeb
            ? null
            : 'mcjrbcjffkecfijvfmxa.supabase.co://login-callback/',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Check your email for a login link!')),
        );
        _emailController.clear();
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
    // TODO: Implement init state
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
                  // if (_formKey.currentState!.validate()) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text('Processing Data')),
                  //   );
                  _isLoading ? null : _signIn();
                  // }
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
