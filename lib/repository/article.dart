import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:posttree/model/article.dart';
import 'package:posttree/model/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posttree/model/user.dart';

final articleRepositoryProvider =
    Provider((ref) => ArticleRepositoryFirestoreImpl());

abstract class ArticleRepository {
  Future<Article> findById(String id);
  Future<List<Article>> batchGetByAuthorId(String id);

  Future<void> insert(Article record);
}

class ArticleRepositoryFirestoreImpl implements ArticleRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<Article>> batchGetByAuthorId(String id) async {
    CollectionReference articles = firestore.collection('articles');
    final result = await articles
        .where('author.user_id', isEqualTo: id)
        .orderBy('created_at', descending: true)
        .get();
    return List.generate(result.docs.length, (i) {
      var document = result.docs[i].data() as Map<String, dynamic>;
      return newArticle(document);
    });
  }

  @override
  Future<Article> findById(String id) {
    // TODO: implement findById
    throw UnimplementedError();
  }

  @override
  Future<void> insert(Article record) async {
    CollectionReference articles = firestore.collection('articles');
    await articles.add(record.toMap());
  }
}
