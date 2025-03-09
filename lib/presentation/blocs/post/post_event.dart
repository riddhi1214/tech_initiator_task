abstract class PostEvent {}

class AddPost extends PostEvent {
  final String message;
  AddPost(this.message);
}

class LoadPosts extends PostEvent {}

class PostUpdated extends PostEvent {
  final List<Map<String, dynamic>> posts;
  PostUpdated(this.posts);
}