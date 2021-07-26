import 'dart:async';
import 'package:posttree/model/post.dart';
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
  ),
);

class HomeViewModel extends ChangeNotifier {
  // Static
  final AccountRepository accountRepository;
  HomeViewModel({required this.accountRepository});

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
  Future<void> refreshSelf() async {
    try {
      final user =
          await accountRepository.verifyUser(ServiceId(id: "posttree"));
      this._selfUser = user;
      _voidEventAction.sink.add(EventSuccess());
    } catch (e) {
      logger.warning('Exception: ${e.toString()}');
      _voidEventAction.sink.add(EventFailed());
    } finally {
      notifyListeners();
    }
  }

  Future<void> refreshTimeline() async {
    try {
      await Future.delayed(Duration(seconds: 1));
      this._timelineItems.insert(
          0,
          Post(
              id: randomString(10),
              message: randomString(50),
              user: User(
                  userId: UserId(id: randomString(10)),
                  userName: UserName(value: randomString(5)),
                  userIconImage: UserIconImage(
                      value:
                          "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg")),
              isMine: false));
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
