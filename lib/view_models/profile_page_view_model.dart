import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/repositories/repository.dart';
import 'package:sosyal_ag/utils/locator.dart';


class ProfilePageViewModel extends ChangeNotifier {



  final PagingController<int, PostModel> pagingController = PagingController(
    getNextPageKey: (PagingState<int, PostModel> state) {
      return (state.keys?.last ?? 0) + 1;
    },
    fetchPage: (int pageKey) async {
      final Repository repository = locator<Repository>();
      return await repository.getMoreUserPosts(
        "sQcuYEWC8HfxLLEl0GXIxRsPqFI2",
        "pyrsWQFLxpAjAQax8PKa",
        pageKey,
      );
    },
  );

} 