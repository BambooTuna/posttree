import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:posttree/utils/event.dart';
import 'package:posttree/view_model/authentication.dart';
import 'package:posttree/view_model/post_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> openPostFormModal(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      builder: (c) {
        return SingleChildScrollView(
            child: AnimatedPadding(
          duration: Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: MediaQuery.of(c).viewInsets.bottom),
          child: PostForm(),
        ));
      });
}

class PostForm extends StatefulWidget {
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  late StreamSubscription<Event> _subscription;

  @override
  void initState() {
    super.initState();

    var viewModel = context.read(postFormViewModelProvider);
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
    return Consumer(builder: (context, watch, child) {
      final viewModel = watch(postFormViewModelProvider);
      final authenticationViewModel = watch(authenticationViewModelProvider);

      final formKey = viewModel.formKey;
      return Container(
        padding: EdgeInsets.all(20),
        child: FormBuilder(
          key: formKey,
          initialValue: viewModel.initialValue,
          autovalidateMode: AutovalidateMode.always,
          onWillPop: () async {
            viewModel.cacheValue();
            return true;
          },
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  icon: Icon(
                    Icons.send_sharp,
                    color:
                        Theme.of(context).buttonTheme.colorScheme?.background,
                  ),
                  label: const Text("送信"),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).buttonTheme.colorScheme?.primary,
                    onPrimary:
                        Theme.of(context).buttonTheme.colorScheme?.onPrimary,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    viewModel.send(authenticationViewModel.selfUser);
                  },
                ),
              ],
            ),
            FormBuilderTextField(
              name: "content",
              autofocus: true,
              maxLines: 5,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
                FormBuilderValidators.maxLength(context, 150),
              ]),
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 48),
          ]),
        ),
      );
    });
  }

  @override
  void dispose() {
    // broadcast streamをlistenしている場合は毎回subscriptionを閉じないといけない
    _subscription.cancel();
    super.dispose();
  }
}
