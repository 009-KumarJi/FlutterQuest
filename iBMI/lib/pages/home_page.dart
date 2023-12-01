import 'package:flutter/cupertino.dart';
import 'package:ibmi/pages/bmi_page.dart';
import 'package:ibmi/pages/history_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Widget> _tabs = [BMIPage(), HistoryPage()];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('iBMI'),
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.house_alt_fill,
                color: CupertinoColors.white,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.circle_grid_hex_fill,
                color: CupertinoColors.white,
              ),
            ),
          ],
        ),
        tabBuilder: (context, index) => CupertinoTabView(
            builder: (context) => _tabs[index],
          ),
      ),
    );
  }
}
