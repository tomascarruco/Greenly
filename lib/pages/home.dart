import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = TextTheme.of(context);

    final width = MediaQuery.sizeOf(context).width;
    final images = ['Food', 'Housing', 'Energy', 'Transportation'];

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
              backgroundColor: Colors.white,
              itemExtent: MediaQuery.of(context).size.width * 0.8,
              itemSnapping: true,
              children: List<Widget>.generate(4, (int id) {
                return Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  // fit: StackFit.passthrough,
                  children: <Widget>[
                    ClipRect(
                      child: OverflowBox(
                        maxWidth: width / 2.5,
                        maxHeight: width / 2.5,
                        child: Image.asset(
                          'assets/images/${images[id]}.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.all(18.0),
                      child: Text(
                        images[id],
                        overflow: TextOverflow.clip,
                        softWrap: false,
                        style: textTheme.titleMedium,
                      ),
                    ),
                  ],
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
