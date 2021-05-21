import 'package:behealthy/meal_selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:behealthy/constants.dart';
import 'package:behealthy/homePage.dart';
import 'package:flutter/rendering.dart';
import 'constants.dart';
import 'homePage.dart';

class CartCheckout extends StatefulWidget {
  @override
  _CartCheckoutState createState() => _CartCheckoutState();
}

class _CartCheckoutState extends State<CartCheckout> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomAppBar(
          //shape: CircularNotchedRectangle(),
          //notchMargin: 4.0,
          elevation: 100,
          child: SafeArea(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CartCheckout()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 300,
                    height: 45,
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pay with',
                          style: BeHealthyTheme.kMainTextStyle.copyWith(
                              fontSize: 12, color: BeHealthyTheme.kMainOrange),
                        ),
                        Text(
                          'Cash',
                          style: BeHealthyTheme.kProfileFont.copyWith(
                            fontSize: 14,
                            color: Color(0xff707070),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 150,
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: BeHealthyTheme.kMainOrange,
                          borderRadius: BorderRadius.circular(25)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Place Order ',
                            style: BeHealthyTheme.kMainTextStyle
                                .copyWith(fontSize: 18, color: Colors.white),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.6,
              child: Container(
                width: 530,
                height: 650,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/Path 29.png'))),
                child: Stack(
                  children: [
                    Positioned(
                      top: 415,
                      left: 70,
                      child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 25,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MealSelection()));
                          }),
                    ),
                    Positioned(
                      top: 457,
                      left: 90,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'عربة التسوق',
                            style: BeHealthyTheme.kMainTextStyle
                                .copyWith(fontSize: 19, color: Colors.white),
                          ),
                          Text(
                            'Cart Checkout',
                            style: BeHealthyTheme.kMainTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        top: 120,
                        left: 350,
                        child: Image(
                            width: 71,
                            height: 455,
                            image: AssetImage('assets/images/login_lamp.png'))),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        child: Image(
                            width: 71,
                            height: 455,
                            image: AssetImage('assets/images/Untitled-1.png')))
                  ],
                ),
              ),
            ),
            Positioned(
              top: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 160,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 3),
                            color: Colors.black12,
                            blurRadius: 12,
                          )
                        ],
                        color: Colors.white),
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 18.0, left: 0, bottom: 15),
                            child: Text(
                              'Ramadan Basic Plan',
                              style: BeHealthyTheme.kDeliverToStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: BeHealthyTheme.kMainOrange),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/Dinner.png',
                                      width: 45,
                                      height: 45,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      'Quality',
                                      style: BeHealthyTheme.kProfileFont
                                          .copyWith(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '26',
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(
                                              fontSize: 22,
                                              color:
                                                  BeHealthyTheme.kMainOrange),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: 60,
                                  child: VerticalDivider(
                                    color: Colors.black26,
                                    width: 20,
                                  )),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/send.png',
                                    width: 48,
                                    height: 49,
                                  ),
                                  SizedBox(
                                    height: 0,
                                  ),
                                  Text(
                                    'Amount',
                                    style: BeHealthyTheme.kProfileFont.copyWith(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '99',
                                    style: BeHealthyTheme.kMainTextStyle
                                        .copyWith(
                                            fontSize: 22,
                                            color: BeHealthyTheme.kMainOrange),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: 60,
                                  child: VerticalDivider(
                                    color: Colors.black26,
                                    width: 20,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(right: 25),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/take-away (3).png',
                                      width: 45,
                                      height: 45,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      'Order id',
                                      style: BeHealthyTheme.kProfileFont
                                          .copyWith(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '1342',
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(
                                              fontSize: 22,
                                              color:
                                                  BeHealthyTheme.kMainOrange),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                          style: BeHealthyTheme.kMainTextStyle.copyWith(
                              fontSize: 15, color: BeHealthyTheme.kMainOrange),
                        ),
                        Icon(Icons.edit_outlined,
                            color: BeHealthyTheme.kMainOrange, size: 16),
                      ]),
                  Text(
                    'Vishesh Kumar',
                    style: BeHealthyTheme.kProfileFont
                        .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivering to',
                          style: BeHealthyTheme.kMainTextStyle.copyWith(
                              fontSize: 15, color: BeHealthyTheme.kMainOrange),
                        ),
                        Icon(Icons.edit_outlined,
                            color: BeHealthyTheme.kMainOrange, size: 16),
                      ]),
                  Text(
                    'ZYC Colony, Kuwait',
                    style: BeHealthyTheme.kProfileFont
                        .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 300,
                    child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 160,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 3),
                                      color: Colors.black12,
                                      blurRadius: 12,
                                    )
                                  ],
                                  color: BeHealthyTheme.kLightOrange),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 18.0, left: 25, bottom: 15),
                                      child: Text(
                                        '6th May, Thu',
                                        style: BeHealthyTheme.kDeliverToStyle
                                            .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    BeHealthyTheme.kMainOrange),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 25),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/Lunch.png',
                                                width: 50,
                                                height: 50,
                                              ),
                                              SizedBox(
                                                height: 0,
                                              ),
                                              Text(
                                                'Lunch',
                                                style: BeHealthyTheme
                                                    .kProfileFont
                                                    .copyWith(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: BeHealthyTheme
                                                            .kMainOrange),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Beef Steak',
                                                    style: BeHealthyTheme
                                                        .kProfileFont
                                                        .copyWith(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    ' 1',
                                                    style: BeHealthyTheme
                                                        .kProfileFont
                                                        .copyWith(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: BeHealthyTheme
                                                                .kMainOrange),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/soup.png',
                                              width: 50,
                                              height: 50,
                                            ),
                                            SizedBox(
                                              height: 0,
                                            ),
                                            Text(
                                              'Soup',
                                              style: BeHealthyTheme.kProfileFont
                                                  .copyWith(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: BeHealthyTheme
                                                          .kMainOrange),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Corn Soup',
                                                  style: BeHealthyTheme
                                                      .kProfileFont
                                                      .copyWith(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  ' 3',
                                                  style: BeHealthyTheme
                                                      .kProfileFont
                                                      .copyWith(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: BeHealthyTheme
                                                              .kMainOrange),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 25),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/turkey.png',
                                                width: 50,
                                                height: 50,
                                              ),
                                              SizedBox(
                                                height: 0,
                                              ),
                                              Text(
                                                'Dinner',
                                                style: BeHealthyTheme
                                                    .kProfileFont
                                                    .copyWith(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: BeHealthyTheme
                                                            .kMainOrange),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Chicken',
                                                    style: BeHealthyTheme
                                                        .kProfileFont
                                                        .copyWith(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    ' 2',
                                                    style: BeHealthyTheme
                                                        .kProfileFont
                                                        .copyWith(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: BeHealthyTheme
                                                                .kMainOrange),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
