// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/cubits/region_cubit.dart';
import 'package:news/ui/screens/filterednews.dart';

class RegionsScreen extends StatefulWidget {
  @override
  State<RegionsScreen> createState() => _RegionsScreenState();
}

class _RegionsScreenState extends State<RegionsScreen>
    with AutomaticKeepAliveClientMixin {
  late RegionCubit regionCubit;
  @override
  void initState() {
    super.initState();
    regionCubit = context.read<RegionCubit>();
    regionCubit.fetchRegions();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchRegions() {
    context.read<RegionCubit>().fetchRegions();
  }

  Widget ErrorContainer(
      {required String errorMessageCode, required Null Function() onTapRetry}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: MediaQuery.of(context).size.width * (0.075),
      ),
      child: Column(
        children: [
          Text('no countries found' + errorMessageCode),
          ElevatedButton(onPressed: onTapRetry(), child: Text('retry'))
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocBuilder<RegionCubit, RegionState>(
        builder: (BuildContext context, state) {
          if (state is RegionInitial || state is RegionFetchInProgress) {
            return Center(child: CircularProgressIndicator());
          } else if (state is RegionFetchSuccess) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
              ),
              itemCount: state.regions.length,
              itemBuilder: (context, index) {
                final region = state.regions[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FilteredNews(countryCode: region.queryCode)),
                  ),
                  child: Card(
                    child: Center(
                      child: Text(
                        region.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          if (state is RegionFetchFailure) {
            return Center(
              child: ErrorContainer(
                errorMessageCode: state.errorMessage,
                onTapRetry: () {
                  context.read<RegionCubit>().fetchRegions();
                },
              ),
            );
          } else {
            return Center(child: Text('Unexpected state'));
          }
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
