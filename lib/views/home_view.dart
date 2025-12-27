import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/users_controller.dart';
import '../controllers/history_controller.dart';
import '../views/users_tab.dart';
import '../views/history_tab.dart';

class HomeView extends StatelessWidget {
  final UsersController usersController = Get.put(UsersController());
  final HistoryController historyController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (ctx, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                centerTitle: true,
                title: _Switcher(),
                backgroundColor: Colors.white,
                elevation: 1,
                pinned: false,
              )
            ];
          },
          body: _TabsContent(),
        ),
      ),
    );
  }
}

class _Switcher extends StatefulWidget {
  @override
  State<_Switcher> createState() => _SwitcherState();
}

class _SwitcherState extends State<_Switcher> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    final labels = ['Users', 'Chat History'];
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(labels.length, (i) {
          final sel = i == selected;
          return GestureDetector(
            onTap: () {
              setState(() => selected = i);
              DefaultTabController.of(context)?.animateTo(i);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
              decoration: sel
                  ? BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(26),
              )
                  : null,
              child: Text(
                labels[i],
                style: TextStyle(color: sel ? Colors.white : Colors.black87, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _TabsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        UsersTab(), // has its own FAB logic in separate widget
        HistoryTab(),
      ],
    );
  }
}
