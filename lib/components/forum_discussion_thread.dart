import 'package:flutter/material.dart';

/// ForumDiscussionThread - Present basic thread information such as [topic],
/// [poster] and current interaction [metrics]
class ForumDiscussionThread extends StatelessWidget {
  final int? upVotes;
  final int? downVotes;
  final String topic;
  final String poster;

  const ForumDiscussionThread({
    super.key,
    required this.topic,
    required this.poster,
    this.upVotes,
    this.downVotes,
  });

  @override
  Widget build(BuildContext context) {
    var cardShape = RoundedRectangleBorder(
      side: BorderSide(
        color: Colors.grey.shade300,
        width: 2,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    );

    var textTheme = TextTheme.of(context);

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: cardShape,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 22,
              children: [
                // Avatar
                CircleAvatar(
                  backgroundColor: Colors.green.shade700,
                  child: const Text('A'),
                ),
                // TOPIC AND POSTER
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(topic, style: textTheme.titleMedium),
                    Text(
                      '@$poster',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Metrics
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 8,
              children: [
                Builder(
                  builder: (context) {
                    if (upVotes != null) {
                      return Row(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.thumb_up_outlined,
                            size: 22,
                            color: Colors.black54,
                          ),
                          Text(upVotes.toString()),
                        ],
                      );
                    }
                    return SizedBox();
                  },
                ),
                Builder(
                  builder: (context) {
                    if (downVotes != null) {
                      return Row(
                        spacing: 8,
                        children: [
                          Icon(
                            Icons.thumb_down_outlined,
                            size: 22,
                            color: Colors.grey.shade400,
                          ),
                          Text(downVotes.toString()),
                        ],
                      );
                    }
                    return SizedBox();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
