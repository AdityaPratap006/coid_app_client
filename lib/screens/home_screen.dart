import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/hotspot_locations.dart';
//Screens
import './hotspots_screen.dart';
import './directions_screen.dart';
import './user_profile_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _screens = [
    HotspotsScreen(),
    DirectionsScreen(),
    UserProfileScreen(),
    UserProfileScreen(),
  ];

  int _selectedScreenIndex = 0;
  bool _loadingCovidLocations = false;

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _loadingCovidLocations = true;
    });

    Provider.of<HotspotLocations>(context, listen: false)
        .fetchAndSetLocations()
        .then((_) {
      setState(() {
        _loadingCovidLocations = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loadingCovidLocations
        ? Center(
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Text(
                        'Fetching all locations with covid19 cases',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            body: _screens[_selectedScreenIndex],
            bottomNavigationBar: BottomNavigationBar(
              elevation: 12,
              onTap: _selectScreen,
              backgroundColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.white,
              selectedItemColor: Theme.of(context).accentColor,
              currentIndex: _selectedScreenIndex,
              items: [
                BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).primaryColor,
                  icon: Icon(Icons.location_on),
                  title: Text(
                    'Covid Radar',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).primaryColor,
                  icon: Icon(Icons.directions_car),
                  title: Text(
                    'Routes',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).primaryColor,
                  icon: Icon(Icons.show_chart),
                  title: Text(
                    'Insights',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).primaryColor,
                  icon: Icon(Icons.person),
                  title: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
