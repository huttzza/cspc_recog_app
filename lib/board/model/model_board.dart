import 'package:cspc_recog/urls.dart';
import 'package:cspc_recog/board/model/api_adapter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Board{
  String boardName;
  int boardId;
  Board({this.boardId, this.boardName});

  Board.fromJson(Map<String,dynamic> json)
    : boardName = json['board_name'],
      boardId = json['id'];
}
Future<List<Board>> getBoardList(context, groupId) async {
  List<Board> boardList = [];
  try{
    final response = await http.get(
        Uri.parse(UrlPrefix.urls+'board/group/'+groupId.toString())
    );
    if(response.statusCode == 200) {
        boardList = parseBoardList(utf8.decode(response.bodyBytes));
    }
    else{
      throw Exception('falied get board list groupId!'+groupId.toString());
    }
  }
  catch(e){
    print(e);
  }

  return boardList;
}
class Post{
  String title;
  int authorId;
  String nickName;
  String contents;
  DateTime createdTime;
  int id;
  int like;
  bool hasImage;
  Post(
      { this.id, //post id
        this.title,
        this.authorId, //profile id
        this.nickName, //profile name
        this.contents,
        this.createdTime,
        this.like,
        this.hasImage}
      );

  Post.fromJson(Map<String,dynamic> json)
      : id = json['id'],
        title = json['title'],
        authorId = json['author'],
        nickName = json['nickname'],
        contents = json['contents'],
        createdTime = DateTime.parse(json['created_date']),
        like = json['like_count'],
        hasImage = json['has_image'];
}

Future<Post> getPost(context, postId) async{
  Post post;
  final response = await http.get(Uri.parse(UrlPrefix.urls+'board/post/'+postId.toString()));
  if(response.statusCode == 200) {
      Map<String,dynamic> postMap = jsonDecode(utf8.decode(response.bodyBytes));
      post = Post.fromJson(postMap);
  }
  else{
    throw Exception('falied!');
  }
  return post;
}

Future<List<Post>> getPostList(context,boardId, page) async{
  List<Post> postList = [];
  Map<String,String> queryParameters = {
    'page': page.toString(),
  };
  print("page"+page.toString());

  Uri uri = Uri.parse(UrlPrefix.urls+'board/'+boardId.toString());
  final finalUri = uri.replace(queryParameters: queryParameters);
  final response = await http.get(finalUri);
  if(response.statusCode == 200) {
      postList = parsePostList(utf8.decode(response.bodyBytes));
      print("hehe!" + postList.length.toString());
  }
  else{
    postList = [];
  }
  return postList;
}

class ImageUrl{
  String imgUrl;

  ImageUrl({this.imgUrl});

  ImageUrl.fromJson(Map<String,dynamic> json)
    : imgUrl = json['image'];
}

Future<List<ImageUrl>> getImages(context, postId) async{
  List<ImageUrl> imageList = [];
  final imgResponse = await http.get(
      Uri.parse(UrlPrefix.urls + 'board/image/' + postId.toString()));
  if(imgResponse.statusCode == 200){
      imageList = parseImgs(utf8.decode(imgResponse.bodyBytes));
  }
  else{
    throw Exception('Get image falied postId!'+postId.toString());
  }
  return imageList;
}


class Comment{
  int authorId;
  String nickName;
  String contents;
  DateTime createdTime;
  int postId;
  int id;
  Comment({this.id,this.authorId, this.nickName, this.contents,this.createdTime,this.postId});

  Comment.fromJson(Map<String,dynamic> json)
      : id = json['id'],
        authorId = json['author'],
        nickName = json['nickname'],
        contents = json['contents'],
        createdTime = DateTime.parse(json['created_date']),
        postId = json['post_id'];
}

Future<List<Comment>> getCommentList(context, postId) async{
  List<Comment> commentList = [];
  final commentResponse = await http.get(Uri.parse(UrlPrefix.urls+'board/comment/'+postId.toString()));
  if(commentResponse.statusCode == 200) {
    commentList = parseComments(utf8.decode(commentResponse.bodyBytes));
  }
  else{
    throw Exception('falied get comment List post Id!'+postId.toString());
  }
  return commentList;
}