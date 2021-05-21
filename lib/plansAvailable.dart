import 'package:behealthy/constants.dart';
import 'package:behealthy/loginScreen.dart';
import 'package:behealthy/mealPlan.dart';
import 'package:behealthy/mealsAvailable.dart';
import 'package:behealthy/providers/dashboard_items_dbprovider.dart';
import 'package:behealthy/providers/getDataFromApi.dart';
import 'package:flutter/material.dart';

class PlansAvailableScreen extends StatefulWidget {
  @override
  _PlansAvailableScreenState createState() => _PlansAvailableScreenState();
}

class _PlansAvailableScreenState extends State<PlansAvailableScreen> {
  var isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadFromApi();
  }

  @override
  Widget build(BuildContext context) {
    Size medq = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          setState(() {
            _loadFromApi();
          });
        },
        child: CircleAvatar(
          backgroundColor: BeHealthyTheme.kMainOrange,
          radius: 30,
          child: Icon(Icons.refresh, size: 30, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Positioned(
                top: -medq.height * 0.57,
                child: Image(
                  image: AssetImage('assets/images/Path 29.png'),
                )),
            Positioned(
              left: medq.width / 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: medq.width * 0.46,
                    alignment: Alignment.topRight,
                    child: Text(
                      'الخطط',
                      style: BeHealthyTheme.kMainTextStyle
                          .copyWith(fontSize: 33, color: Colors.white),
                    ),
                  ),
                  Text(
                    'Plans Available',
                    style: BeHealthyTheme.kMainTextStyle
                        .copyWith(color: Colors.white, fontSize: 25),
                  ),
                ],
              ),
            ),
            Positioned(
                top: -medq.height * 0.35,
                left: medq.width * 0.65,
                child: Image(
                    width: 71,
                    height: 455,
                    image: AssetImage('assets/images/login_lamp.png'))),
            Positioned(
                top: medq.height / 30,
                left: medq.width * 0.85,
                child: Image(
                    width: 40,
                    height: 40,
                    color: Colors.white,
                    image: AssetImage('assets/images/bh_logo.png'))),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : _buildGetPackageListView(),
              ),
            )
          ],
        ),
      ),
    );
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = DataApiProvider();
    await apiProvider.getAllPackages();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllPackages();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    print('All data deleted');
  }

  _buildGetPackageListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllPackages(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // print(snapshot.data);
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: CustomCard(
                  image: snapshot.data[index]['planImage'],
                  title: snapshot.data[index]['planName'],
                  desc: snapshot.data[index]['planWeight'],
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MealsAvailableScreen(
                                snapshot.data[index]['planName'],
                                snapshot.data[index]['planID'])));
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}

class CustomCard extends StatelessWidget {
  final String image;
  final String title;
  final Function onTap;
  final String desc;
  const CustomCard({
    this.desc,
    this.onTap,
    this.image,
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: BeHealthyTheme.kMainOrange.withOpacity(0.11),
            borderRadius: BorderRadiusDirectional.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(
                  image: NetworkImage(image),
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.height * 0.1,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        title,
                        style: BeHealthyTheme.kMainTextStyle.copyWith(
                            color: BeHealthyTheme.kMainOrange, fontSize: 22),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        desc,
                        textAlign: TextAlign.start,
                        style: BeHealthyTheme.kDhaaTextStyle
                            .copyWith(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
