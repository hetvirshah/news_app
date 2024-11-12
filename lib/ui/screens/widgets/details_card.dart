import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../data/class models/news_class.dart';

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
