import 'package:flutter/material.dart';

typedef FetchPageData<T> = Future<List<T>> Function(int page);
typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item, int index);
typedef EmptyWidgetBuilder = Widget Function(BuildContext context);

class PaginatedListView<T> extends StatefulWidget { // 空数据视图

  const PaginatedListView({
    required this.fetchData, required this.itemBuilder, super.key,
    this.pageSize = 10,
    this.emptyBuilder,
  });
  final FetchPageData<T> fetchData; // 异步获取数据
  final ItemWidgetBuilder<T> itemBuilder; // 渲染每个 item
  final int pageSize;
  final EmptyWidgetBuilder? emptyBuilder;

  @override
  _PaginatedListViewState<T> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  final ScrollController _scrollController = ScrollController();
  List<T> items = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;

  // 控制“回到顶部”按钮显示
  bool showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _loadData();

    _scrollController.addListener(() {
      // 触发分页加载
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50 &&
          !isLoading &&
          hasMore) {
        _loadData();
      }

      // 控制显示回到顶部按钮
      if (_scrollController.offset > 300 && !showScrollToTop) {
        setState(() => showScrollToTop = true);
      } else if (_scrollController.offset <= 300 && showScrollToTop) {
        setState(() => showScrollToTop = false);
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

        if (newData.length < widget.pageSize) {
          hasMore = false;
        } else {
          page++;
        }

        isLoading = false;
      });

      // 刷新时自动回到顶部
      if (refresh) {
        _scrollToTop();
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }


  Future<void> _onRefresh() async {
    await _loadData(refresh: true);
  }



  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty && !isLoading) {
      // 空数据展示
      return widget.emptyBuilder?.call(context) ??
          const Center(child: Text("暂无数据"));
    }

    return Stack(
      children: [
        RefreshIndicator(
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
        ),
        // 回到顶部按钮
        if (showScrollToTop)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              mini: true,
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
