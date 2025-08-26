import 'package:flutter/material.dart';
import 'package:greenly/components/emission_monthly_delta.dart';
import 'package:greenly/components/forum_discussion_thread.dart';

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
          // --- START GHG Calculation overview
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
                color: Theme.of(context).colorScheme.primaryFixedDim,
                minHeight: 10,
                value: 0.33,
              ),
            ],
          ),
          // --- END GHG Calculation overview
          SizedBox(height: 33),
          // --- START Emission Tracking
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 12,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 6,
                children: [
                  Text('Emission Tracking', style: textTheme.titleLarge),
                  Text('Overall: Reduced emissions by 300Kg in three months'),
                ],
              ),
              Column(
                children: const <Widget>[
                  EmissionMonthlyDelta('12/04/2025', 1.44, 0.2),
                  EmissionMonthlyDelta('12/03/2025', 1.42, -0.5),
                  EmissionMonthlyDelta('12/02/2025', 1.47, 0.0),
                ],
              ),
            ],
          ),
          // --- END Emission Tracking
          SizedBox(height: 33),
          // --- START Comunity Forum
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 10,
            children: [
              Text('What are peoople saying?', style: textTheme.titleLarge),
              Column(
                children: const <Widget>[
                  ForumDiscussionThread(
                    topic: 'Composting Tips and Tricks',
                    poster: 'greenlyUser97',
                    upVotes: 12,
                    downVotes: 2,
                  ),
                  ForumDiscussionThread(
                    topic: 'Composting Tips and Tricks',
                    poster: 'greenlyUser97',
                    upVotes: 22,
                    downVotes: 4,
                  ),
                ],
              ),
            ],
          ),
          // --- END Comunity Forum
        ],
      ),
    );
  }
}
