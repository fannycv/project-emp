import 'package:clothing_identifier/screens/my_uploads/my_clothings.dart';
import 'package:clothing_identifier/screens/my_uploads/my_outfits.dart';
import 'package:flutter/material.dart';

class MyUploadView extends StatefulWidget {
  const MyUploadView({super.key});

  @override
  State<MyUploadView> createState() => _MyUploadViewState();
}

class _MyUploadViewState extends State<MyUploadView>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(child: Text('Clothings')),
            Tab(
              child: Text('Outfits'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          MyClothingView(),
          MyOutfitView(),
        ],
      ),
    );
  }
}
