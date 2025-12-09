import 'package:flutter/material.dart';

typedef FetchPageData<T> = Future<List<T>> Function(int page);
typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item, int index);

class PaginatedListView<T> extends StatefulWidget {
  final FetchPageData<T> fetchData; // 异步获取数据
  final ItemWidgetBuilder<T> itemBuilder; // 渲染每个 item
  final int pageSize;

  const PaginatedListView({
    super.key,
    required this.fetchData,
    required this.itemBuilder,
    this.pageSize = 10,
  });

  @override
  _PaginatedListViewState<T> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  final ScrollController _scrollController = ScrollController();
  List<T> items = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100 &&
          !isLoading &&
          hasMore) {
        _loadData();
      }
    });
  }

  Future<void> _loadData({bool refresh = false}) async {
    if (isLoading) return;
    setState(() => isLoading = true);

    if (refresh) {
      page = 1;
      hasMore = true;
    }

    try {
      List<T> newData = await widget.fetchData(page);
      setState(() {
        if (refresh) {
          items = newData;
        } else {
          items.addAll(newData);
        }

        if (newData.length < widget.pageSize) hasMore = false;
        else page++;

        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      // 可以加错误处理
    }
  }

  Future<void> _onRefresh() async {
    await _loadData(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index < items.length) {
            return widget.itemBuilder(context, items[index], index);
          } else {
            if (hasMore) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: Text("没有更多数据")),
              );
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
