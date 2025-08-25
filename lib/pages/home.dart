import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = TextTheme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Your last GHG calculation.', style: textTheme.titleLarge),
          SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: CarouselView(
              backgroundColor: Colors.grey.shade400,
              itemExtent: MediaQuery.of(context).size.width * 0.8,
              children: List<Widget>.generate(4, (int id) {
                return Image.asset(
                  'assets/images/600x400.png',
                  fit: BoxFit.cover,
                );
              }),
            ),
          ),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 5,
            children: [
              Text('Good Start! Only 3 more steps', style: textTheme.bodySmall),
              LinearProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.surfaceDim,
                borderRadius: BorderRadiusGeometry.circular(25),
                color: Theme.of(context).colorScheme.primary,
                minHeight: 10,
                value: 0.33,
              ),
            ],
          ),
          SizedBox(height: 33),
        ],
      ),
    );
  }
}
