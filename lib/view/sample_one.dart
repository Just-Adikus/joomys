import 'package:flutter/material.dart';
import 'package:joomys/view/add_screen.dart';
import 'package:joomys/view/company_screen.dart';
import 'package:joomys/view/main_screen.dart';
import 'package:joomys/view/search_screen.dart';
import 'package:joomys/view/user_profile_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class SampleOne extends StatefulWidget {
  const SampleOne({super.key,required this.token});
  final String token;
  @override
  State<SampleOne> createState() => _SampleOneState();
}

class _SampleOneState extends State<SampleOne> {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: MainScreen(token: widget.token,),
          item: ItemConfig(
            icon: Icon(Icons.home_outlined,color: Colors.blueAccent,),
            title: "Home",
          ),
        ),
        PersistentTabConfig(
          screen: SearchScreen(token: widget.token,),
          item: ItemConfig(
            icon: Icon(Icons.search,color: Colors.blueAccent,),
            title: "search",
          ),
        ),
        PersistentTabConfig(
          screen:AddScreen(token: widget.token,),
          item: ItemConfig(
            icon: Icon(Icons.add_circle_outline_outlined,color: Colors.blueAccent, ),
            title: "add job or company",
          ),
        ),
        PersistentTabConfig(
          screen:CompanyScreen(token: widget.token,),
          item: ItemConfig(
            icon: Icon(Icons.work_outline,color: Colors.blueAccent, ),
            title: "info",
          ),
        ),
        PersistentTabConfig(
          screen:UserProfileScreen(token: widget.token,),
          item: ItemConfig(
            icon: Icon(Icons.person_outline,color: Colors.blueAccent,),
            title: "user",
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style10BottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}
