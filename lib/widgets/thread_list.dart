import 'package:flutter/material.dart';
import 'package:meetuper_app/blocs/meetup_bloc.dart';
import 'package:meetuper_app/models/thread.dart';
import 'package:meetuper_app/other/posts.dart';

import 'package:timeago/timeago.dart' as timeago;

class ThreadList extends StatelessWidget {
  final MeetupBloc bloc;

  ThreadList({required this.bloc}) : assert(bloc != null);

  Widget build(BuildContext context) {
    return StreamBuilder<List<Thread>>(
        stream: bloc.threads,
        builder: (BuildContext context, AsyncSnapshot<List<Thread>> snapshot) {
          if (snapshot.hasData) {
            final threads = snapshot.data;
            if (threads != null && threads.length > 0) {
              return ListView.builder(
                itemCount: threads.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage: NetworkImage(threads[i].user.avatar),
                                ),
                              ),
                              Expanded(
                                child: Text(threads[i].title, style: const TextStyle(fontSize: 22.0)),
                              )
                            ],
                          ),
                          _PostList(posts: threads[i].posts)
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No Threads Yet',
                    style: const TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic)),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class _PostList extends StatelessWidget {
  final List<Post> posts;

  _PostList({required this.posts});

  String _timeUntil(DateTime date) {
    return timeago.format(date, locale: 'en', allowFromNow: true);
  }

  Widget build(BuildContext context) {
    if (posts != null && posts.length > 0) {
      return Column(
          children: posts.map((Post post) {
        return Container(
          padding: const EdgeInsets.only(left: 10.0, top: 5.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(post.user!.avatar),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_timeUntil(DateTime.parse(post.updatedAt)),
                          style: const TextStyle(fontSize: 12.0, color: Colors.black54)),
                      Text(post.text, style: const TextStyle(fontSize: 16.0, color: Colors.black87))
                    ],
                  ))
            ],
          ),
        );
      }).toList());
    }
    return const Text('No Posts Yet!');
  }
}
