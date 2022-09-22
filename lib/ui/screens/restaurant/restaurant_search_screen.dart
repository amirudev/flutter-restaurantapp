import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp/core/utils/navigation/navigation_utils.dart';
import 'package:restaurantapp/core/viewmodels/restaurant/restaurant_provider.dart';
import 'package:restaurantapp/gen/assets.gen.dart';
import 'package:restaurantapp/ui/constant/constant.dart';
import 'package:restaurantapp/ui/router/route_list.dart';
import 'package:restaurantapp/ui/widgets/idle/idle_item.dart';
import 'package:restaurantapp/ui/widgets/idle/loading/loading_listview.dart';
import 'package:restaurantapp/ui/widgets/restaurant/restaurant_item.dart';
import 'package:restaurantapp/ui/widgets/search/search_item.dart';

class RestaurantSearchScreen extends StatelessWidget {
  const RestaurantSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RestaurantProvider(),
      child: const RestaurantInitSearchScreen(),
    );
  }
}

class RestaurantInitSearchScreen extends StatefulWidget {
  const RestaurantInitSearchScreen({super.key});

  @override
  State<RestaurantInitSearchScreen> createState() =>
      _RestaurantInitSearchScreenState();
}

class _RestaurantInitSearchScreenState
    extends State<RestaurantInitSearchScreen> {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: _searchWidget(),
        leading: IconButton(
          onPressed: () => navigate.pop(),
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
      ),
      body: const RestaurantSearchBody(),
    );
  }

  Widget _searchWidget() {
    return SearchItem(
      controller: searchController,
      autoFocus: true,
      onChange: (value) => RestaurantProvider.instance(context).search(value),
    );
  }
}

class RestaurantSearchBody extends StatelessWidget {
  const RestaurantSearchBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, restaurantProv, _) {
        if (restaurantProv.searchRestaurants == null &&
            !restaurantProv.onSearch) {
          return IdleNoItemCenter(
            title: "What restaurant are you looking for?",
            iconPathSVG: Assets.images.illustrationQuestion.path,
          );
        }

        if (restaurantProv.searchRestaurants == null &&
            restaurantProv.onSearch) {
          return const LoadingListView();
        }

        if (restaurantProv.searchRestaurants!.isEmpty) {
          return IdleNoItemCenter(
            title: "Restaurant not found",
            iconPathSVG: Assets.images.illustrationNotfound.path,
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: restaurantProv.searchRestaurants!.length,
          itemBuilder: (context, index) {
            final restaurant = restaurantProv.searchRestaurants![index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index == 0
                    ? _searchResultWidget(
                        restaurantProv.searchRestaurants!.length,
                      )
                    : const SizedBox(),
                RestaurantItem(
                  restaurant: restaurant,
                  onClick: () => navigate.pushTo(
                    routeRestaurantDetail,
                    data: restaurant,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _searchResultWidget(int total) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: setWidth(40),
        vertical: setHeight(20),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: primaryColor,
            size: 15,
          ),
          Text(
            "$total Restaurants found",
            style: styleTitle.copyWith(
              fontSize: setFontSize(35),
            ),
          )
        ],
      ),
    );
  }
}
