import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posttree/model/post.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:path/path.dart';
import 'package:posttree/model/user.dart';
import 'package:sqflite/sqflite.dart';

final postRepositoryProvider = Provider((ref) => PostRepositoryFirestoreImpl());

abstract class PostRepository {
  Future<Post> findById(String id);
  Future<List<Post>> batchGetByIds(List<String> ids);
  Future<List<Post>> batchGetByAuthorId(String id);

  Future<List<Post>> searchLatest(int n);

  Future<void> insert(Post record);
}

class PostRepositoryFirestoreImpl implements PostRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<Post>> batchGetByAuthorId(String id) async {
    CollectionReference posts = firestore.collection('posts');
    final QuerySnapshot<Object?> result = await posts
        .where('author.user_id', isEqualTo: id)
        .orderBy('created_at', descending: true)
        .get();
    return List.generate(result.docs.length, (i) {
      var document = result.docs[i].data() as Map<String, dynamic>;
      return newPost(document);
    });
  }

  @override
  Future<List<Post>> batchGetByIds(List<String> ids) async {
    throw UnimplementedError();
  }

  @override
  Future<Post> findById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> searchLatest(int n) async {
    CollectionReference posts = firestore.collection('posts');
    final QuerySnapshot<Object?> result =
        await posts.orderBy('created_at', descending: true).limit(n).get();
    return List.generate(result.docs.length, (i) {
      var document = result.docs[i].data() as Map<String, dynamic>;
      return newPost(document);
    });
  }

  @override
  Future<void> insert(Post record) async {
    CollectionReference posts = firestore.collection('posts');
    await posts.add(record.toMap());
  }
}
