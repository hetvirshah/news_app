// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../data/class models/news_class.dart';

class NewsCard extends StatelessWidget {
  final News news;

  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1,
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        news.category?.isNotEmpty ?? false
                            ? Text(
                                news.category!.first,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color.fromRGBO(236, 35, 35, 1),
                                    fontWeight: FontWeight.bold),
                              )
                            : SizedBox.shrink(),
                        SizedBox(height: 4),
                        Text(news.title ?? '',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4), // Add space between texts
                        Text(news.published!.substring(0, 10),
                            style: TextStyle(color: Colors.grey, fontSize: 12))
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      width: 90,
                      height: 80,
                      fit: BoxFit.fill,
                      imageUrl: news.image ?? '',
                      errorWidget: (context, url, error) => Image.asset(
                          width: 90,
                          height: 80,
                          fit: BoxFit.fill,
                          'assets/news.jpeg'),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Newsdetails(news: news)),
            ),
          ),
        ),
        Divider(
          color: Colors.grey[300],
          thickness: 1.0,
          indent: 7.0,
          endIndent: 7.0,
        ),
      ],
    );
  }
}

class Newsdetails extends StatelessWidget {
  final News news;

  const Newsdetails({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Card(
                shadowColor: Colors.black,
                surfaceTintColor: Colors.white,
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${news.title}',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 4,
                          fit: BoxFit.fill,
                          imageUrl: news.image ?? '',
                          errorWidget: (context, url, error) => Image.asset(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 4,
                              fit: BoxFit.fill,
                              'assets/news.jpeg'),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${news.description}.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
