
import 'dart:async';
import 'package:posttree/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:posttree/repository/account.dart';
import 'package:posttree/utils/event.dart';
import 'package:posttree/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationViewModelProvider = ChangeNotifierProvider((ref) => AuthenticationViewModel(
    accountRepository: ref.read(accountRepositoryProvider)));

class AuthenticationViewModel extends ChangeNotifier {
  final AccountRepository accountRepository;
  AuthenticationViewModel({required this.accountRepository});

  User? _selfUser;
  User? get selfUser => _selfUser;
  bool get isLogin => _selfUser != null;

  StreamSubscription<Event> listen() {
    return accountRepository.authState.listen((event) {
      refreshSelfUser();
    });
  }

  refreshSelfUser() async {
    try {
      final user = await accountRepository.currentUser();
      _selfUser = user;
    } catch (e) {
      _selfUser = null;
      logger.warning('Exception: ${e.toString()}');
    } finally {
      notifyListeners();
    }
  }
}