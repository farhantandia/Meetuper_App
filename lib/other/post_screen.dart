import 'package:flutter/material.dart';
import 'package:meetuper_app/other/posts.dart';
import 'package:meetuper_app/other/post_model.dart';
import 'package:meetuper_app/widgets/bottom_navigation_bar.dart';
import 'package:scoped_model/scoped_model.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Widget build(BuildContext context) {
    return ScopedModel<PostModel>(model: PostModel(), child: _PostList());
  }
}

class _InheritedPost extends InheritedWidget {
  final Widget child;
  final List<Post> posts;
  final Function createPost;

  _InheritedPost({required this.child, required this.posts, required this.createPost})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static _InheritedPost of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_InheritedPost>() as _InheritedPost);
  }
}

class _PostList extends StatelessWidget {
  Widget build(BuildContext context) {
    return ScopedModelDescendant<PostModel>(builder: (context, _, model) {
      final posts = model.posts;
      return Scaffold(
        body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(title: Text(posts[index].text), subtitle: Text(posts[index].body)),
            );
          },
        ),
        bottomNavigationBar: BottomNavigation(
          onChange: (int) {},
          userState: null,
          currentIndex: null,
        ),
        floatingActionButton: _PostButton(),
        appBar: AppBar(title: Text(model.testingState)),
      );
    });
  }
}

class _PostButton extends StatelessWidget {
  Widget build(BuildContext context) {
    // final createPost = _InheritedPost.of(context).createPost;
    final postModel = ScopedModel.of<PostModel>(context, rebuildOnChange: true);
    return FloatingActionButton(
        onPressed: postModel.addPost, tooltip: 'Add Post', child: Icon(Icons.add));
  }
}
