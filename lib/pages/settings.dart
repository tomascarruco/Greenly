import 'package:flutter/material.dart';
import 'package:greenly/components/base_layout.dart';

import 'package:greenly/components/emission_monthly_delta.dart';
import 'package:greenly/components/forum_discussion_thread.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePageLayout(
      floatingBtnIcon: Icons.add,
      floatingBtnTooltip: 'Available Actions',
      // --- Body
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [],
        ),
      ),
      hasActionButton: false,
    );
  }
}
