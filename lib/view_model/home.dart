import 'dart:async';
import 'package:posttree/model/post.dart';
import 'package:posttree/repository/post.dart';
import 'package:posttree/utils/event.dart';

import 'package:flutter/material.dart';
import 'package:posttree/model/account.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/repository/account.dart';
import 'package:posttree/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posttree/utils/random.dart';

final homeViewModelProvider = ChangeNotifierProvider(
  (ref) => HomeViewModel(
    accountRepository: ref.read(accountRepositoryProvider),
    postRepository: ref.read(postRepositoryProvider),
  ),
);

class HomeViewModel extends ChangeNotifier {
  // Static
  final AccountRepository accountRepository;
  final PostRepository postRepository;
  HomeViewModel(
      {required this.accountRepository, required this.postRepository});

  // Stream
  var _voidEventAction = StreamController<Event>.broadcast();
  StreamController<Event> get voidEventAction => _voidEventAction;

  // Getter / Setter
  User? _selfUser;
  User? get selfUser => _selfUser;
  bool get isLogin => _selfUser != null;

  List<Post> _timelineItems = [];
  List<Post> get timelineItems => _timelineItems;

  // Function
  Future<void> post(String message) async {
    try {
      if (this._selfUser != null) {
        await postRepository.insert(Post(DateTime.now(),
            id: randomString(10),
            message: message,
            user: _selfUser!,
            isMine: false));
      }
      _voidEventAction.sink.add(EventSuccess());
    } catch (e) {
      logger.warning('Exception: ${e.toString()}');
      _voidEventAction.sink.add(EventFailed());
    } finally {
      notifyListeners();
    }
  }

  Future<void> refreshSelf() async {
    try {
      final user =
          await accountRepository.verifyUser(ServiceId(id: "posttree"));
      this._selfUser = user;
      _voidEventAction.sink.add(EventSuccess());
    } catch (e) {
      this._selfUser = null;
      logger.warning('Exception: ${e.toString()}');
      _voidEventAction.sink.add(EventFailed());
    } finally {
      notifyListeners();
    }
  }

  Future<void> refreshTimeline() async {
    try {
      final posts = await postRepository.searchLatest(20);
      this._timelineItems = posts;
      _voidEventAction.sink.add(EventSuccess());
    } catch (e) {
      logger.warning('Exception: ${e.toString()}');
      _voidEventAction.sink.add(EventFailed());
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // streamを必ず閉じる
    _voidEventAction.close();
    super.dispose();
  }
}
