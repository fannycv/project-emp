import 'package:clothing_identifier/screens/home/clothings.dart';
import 'package:clothing_identifier/screens/home/outfits.dart';
import 'package:flutter/material.dart';

class InicioView extends StatefulWidget {
  const InicioView({super.key});

  @override
  State<InicioView> createState() => _InicioViewState();
}

class _InicioViewState extends State<InicioView> with TickerProviderStateMixin {
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
        children: <Widget>[
          ClothingsView(),
          OutfitsView(),
        ],
      ),
    );
  }
}
