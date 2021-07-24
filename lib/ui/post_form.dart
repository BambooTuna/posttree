import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posttree/utils/event.dart';
import 'package:posttree/view_model/post_form.dart';
import 'package:provider/provider.dart';

Future<void> openPostFormModal(BuildContext context) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
    builder: (_) {
      var viewModel = Provider.of<PostFormViewModel>(context, listen: false);
      return ChangeNotifierProvider.value(
        value: viewModel,
        child: SingleChildScrollView(
            child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: PostForm(),
        )),
      );
    });

class PostForm extends StatefulWidget {
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  late String _initialValue;
  late StreamSubscription<Event> _subscription;
  @override
  void initState() {
    super.initState();

    var viewModel = Provider.of<PostFormViewModel>(context, listen: false);
    _initialValue = viewModel.content;
    _subscription = viewModel.eventAction.stream.listen((event) {
      EasyLoading.dismiss();
      switch (event.runtimeType) {
        case EventSuccess:
          Navigator.of(context).pop();
          break;
        case EventFailed:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PostFormViewModel>(context);
    return Container(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("まだ投稿はできないけど、投稿できる場所だよ"),
            Text(
              viewModel.errorMessage ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: Theme.of(context).errorColor),
            ),
            TextFormField(
                autofocus: true,
                initialValue: _initialValue,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "何か入力してね",
                ),
                onChanged: (text) {
                  viewModel.setContent(text);
                }),
            ElevatedButton(
              child: Text("Send: " + viewModel.content),
              onPressed: () {
                viewModel.send();
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // broadcast streamをlistenしている場合は毎回subscriptionを閉じないといけない
    _subscription.cancel();
    super.dispose();
  }
}
