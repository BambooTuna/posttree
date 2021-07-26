import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posttree/model/post.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:path/path.dart';
import 'package:posttree/model/user.dart';
import 'package:sqflite/sqflite.dart';

final databaseConnectionProvider = Provider(
  (ref) => DatabaseConnection(),
);

class DatabaseConnection {
  Future<Database> conn() async {
    final path = await getDatabasesPath();
    // await deleteDatabase(join(path, 'debug_database.db'));
    return await openDatabase(
      join(path, 'debug_database.db'),
      onCreate: (db, version) async {
        return await db.execute(
          'CREATE TABLE posts(post_id VARCHAR(255) PRIMARY KEY, author_id VARCHAR(255), content VARCHAR(255), created_at DATETIME(6));'
          'CREATE TABLE articles(article_id VARCHAR(255), author_id VARCHAR(255), post_id VARCHAR(255), created_at DATETIME(6), PRIMARY KEY (article_id, post_id));',
        );
      },
      version: 1,
    );
  }
}

final postRepositoryProvider = Provider((ref) => PostRepositoryImpl(
    databaseConnection: ref.read(databaseConnectionProvider)));

abstract class PostRepository {
  Future<Post> findById(String id);
  Future<List<Post>> batchGetByIds(List<String> ids);
  Future<List<Post>> batchGetByAuthorId(String id);

  Future<List<Post>> searchLatest(int n);

  Future<void> insert(Post record);
}

class PostRepositoryImpl implements PostRepository {
  final DatabaseConnection databaseConnection;
  PostRepositoryImpl({required this.databaseConnection});

  Future<String> _getRandImageUrl() async {
    var response = await Dio().get('https://dog.ceo/api/breeds/image/random');
    return response.data["message"];
  }

  // TODO これはまずいw
  Future<List<String>> _getRandImageUrls(int n) async {
    var result = List.filled(n, "");
    for (int i = 0; i < n; ++i) {
      final url = await this._getRandImageUrl();
      result[i] = url;
    }
    return result;
  }

  @override
  Future<List<Post>> batchGetByAuthorId(String id) async {
    final conn = await databaseConnection.conn();
    final List<Map<String, dynamic>> maps =
        await conn.rawQuery('SELECT * FROM posts WHERE author_id = ?', [id]);
    final iconImageUrls = await this._getRandImageUrls(maps.length);
    return List.generate(maps.length, (i) {
      return Post(
        maps[i]['created_at'],
        id: maps[i]['post_id'],
        user: User(
            userId: UserId(id: maps[i]['author_id']),
            userName: UserName(value: maps[i]['author_id']),
            userIconImage: UserIconImage(value: iconImageUrls[i])),
        message: maps[i]['content'],
        isMine: false,
      );
    });
  }

  @override
  Future<List<Post>> batchGetByIds(List<String> ids) async {
    final conn = await databaseConnection.conn();
    final List<Map<String, dynamic>> maps =
        await conn.rawQuery('SELECT * FROM posts WHERE post_id IN ?', ids);
    final iconImageUrls = await this._getRandImageUrls(maps.length);
    return List.generate(maps.length, (i) {
      return Post(
        maps[i]['created_at'],
        id: maps[i]['post_id'],
        user: User(
            userId: UserId(id: maps[i]['author_id']),
            userName: UserName(value: maps[i]['author_id']),
            userIconImage: UserIconImage(value: iconImageUrls[i])),
        message: maps[i]['content'],
        isMine: false,
      );
    });
  }

  @override
  Future<Post> findById(String id) async {
    final conn = await databaseConnection.conn();
    final List<Map<String, dynamic>> maps =
        await conn.rawQuery('SELECT * FROM posts WHERE post_id = ?', [id]);
    final iconImageUrls = await this._getRandImageUrls(maps.length);
    return List.generate(maps.length, (i) {
      return Post(
        maps[i]['created_at'],
        id: maps[i]['post_id'],
        user: User(
            userId: UserId(id: maps[i]['author_id']),
            userName: UserName(value: maps[i]['author_id']),
            userIconImage: UserIconImage(value: iconImageUrls[i])),
        message: maps[i]['content'],
        isMine: false,
      );
    }).first;
  }

  @override
  Future<List<Post>> searchLatest(int n) async {
    final conn = await databaseConnection.conn();
    final List<Map<String, dynamic>> maps = await conn
        .rawQuery('SELECT * FROM posts ORDER BY created_at desc LIMIT ?', [n]);
    final iconImageUrls = await this._getRandImageUrls(maps.length);
    return List.generate(maps.length, (i) {
      return Post(
        DateTime.parse(maps[i]['created_at']),
        id: maps[i]['post_id'],
        user: User(
            userId: UserId(id: maps[i]['author_id']),
            userName: UserName(value: maps[i]['author_id']),
            userIconImage: UserIconImage(value: iconImageUrls[i])),
        message: maps[i]['content'],
        isMine: false,
      );
    });
  }

  @override
  Future<void> insert(Post record) async {
    final conn = await databaseConnection.conn();
    await conn.insert(
      "posts",
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
