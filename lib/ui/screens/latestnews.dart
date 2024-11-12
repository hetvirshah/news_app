import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/cubits/news_cubit.dart';
import 'package:news/ui/screens/widgets/news_card.dart';
import 'package:shimmer/shimmer.dart';

@immutable
class News extends StatefulWidget {
  final String apiUrl;
  final String countryCode;
  final String categories;
  final String languages;

  const News(
      {super.key,
      required this.apiUrl,
      this.countryCode = "",
      this.categories = "",
      this.languages = ""});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> with AutomaticKeepAliveClientMixin {
  final ScrollController newsController = ScrollController();
  late NewsCubit newsCubit;
  bool isIndicate = false;

  @override
  void initState() {
    super.initState();
    newsCubit = context.read<NewsCubit>();
    newsCubit.fetchNews(
        countryCode: widget.countryCode,
        pageNo: 1,
        apiUrl: widget.apiUrl,
        language: widget.languages,
        categories: widget.categories);

    newsController.addListener(() {
      if (newsController.position.atEdge &&
          newsController.position.pixels != 0) {
        isIndicate = true;
        newsCubit.fetchMoreNews(
            apiUrl: widget.apiUrl,
            countryCode: widget.countryCode,
            language: widget.languages,
            categories: widget.categories);
      }
    });
  }

  @override
  void dispose() {
    newsController.dispose();
    super.dispose();
  }

  Widget _loadMore() {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 20.0,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 20.0,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 20.0,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _noMore() {
    return const Center(
      child: Text(
        "No more data",
        style:
            TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<NewsCubit, NewsFetchState>(
      builder: (BuildContext context, state) {
        if (state is NewsFetchStateInit || state is NewsFetchStateLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NewsFetchStateSuccess) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              controller: newsController,
              itemCount: state.latestNews.length + 1,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index < state.latestNews.length) {
                  return NewsCard(news: state.latestNews[index]);
                } else {
                  if (state.hasMoreData && isIndicate) {
                    return _loadMore();
                  } else {
                    if (isIndicate) {
                      return _noMore();
                    }
                  }
                }
                return null;
              },
            ),
          );
        } else if (state is NewsFetchStateFailure) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.errorMsg),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    context.read<NewsCubit>().fetchNews(
                        apiUrl: widget.apiUrl,
                        countryCode: widget.countryCode,
                        language: widget.languages,
                        categories: widget.categories);
                  },
                  child: const Text(
                    "Retry",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
