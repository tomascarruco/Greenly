import 'package:flutter/material.dart';

/// authentication.dart - Provides UI/UX for user authentication

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<StatefulWidget> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = TextTheme.of(context);

    const formLoginTitle = 'Login';

    const innerCardEdgeInsets = EdgeInsets.all(20);
    const scrollViewEdgeInsets = EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 12,
    );

    SizedBox spacer() => (SizedBox(height: 20));

    return SingleChildScrollView(
      padding: scrollViewEdgeInsets,
      child: Card(
        elevation: 1,
        shadowColor: Colors.black54,
        color: Colors.white,
        child: Padding(
          padding: innerCardEdgeInsets,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(formLoginTitle, style: textTheme.titleLarge),
                spacer(),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text('Email'),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      enableSuggestions: true,
                      spellCheckConfiguration:
                          SpellCheckConfiguration.disabled(),
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                spacer(),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text('Password'),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      enableSuggestions: false,
                      spellCheckConfiguration:
                          SpellCheckConfiguration.disabled(),
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'Please enter the password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
