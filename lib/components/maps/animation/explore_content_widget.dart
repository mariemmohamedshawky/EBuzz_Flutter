import 'package:ebuzz/components/maps/animation/ui_helper.dart';
import 'package:flutter/material.dart';

class ExploreContentWidget extends StatelessWidget {
  final double currentExplorePercent;
  final Function(bool) animateExplore;
  final Function(String, bool) togglePlaceType;
  final bool isExploreOpen;

  final placeName = const [
    "Authentic\nrestaurant",
    "Famous\nmonuments",
    "Weekend\ngetaways"
  ];
  const ExploreContentWidget({
    Key key,
    this.currentExplorePercent,
    this.animateExplore,
    this.isExploreOpen,
    this.togglePlaceType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentExplorePercent != 0) {
      return Positioned(
        top: realH(
            standardHeight + (162 - standardHeight) * currentExplorePercent),
        width: screenWidth,
        child: Container(
          height: screenHeight,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Opacity(
                opacity: currentExplorePercent,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Transform.translate(
                            offset: Offset(
                                screenWidth / 3 * (1 - currentExplorePercent),
                                screenWidth /
                                    3 /
                                    2 *
                                    (1 - currentExplorePercent)),
                            child: InkWell(
                              onTap: () {
                                togglePlaceType('hospital', true);
                                animateExplore(!isExploreOpen);
                              },
                              child: Image.asset(
                                "assets/HOSPITAL.png",
                                width: realH(133),
                                height: realH(133),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              togglePlaceType('pharmacy', true);
                              animateExplore(!isExploreOpen);
                            },
                            child: Image.asset(
                              "assets/PHARMACY.png",
                              width: realH(133),
                              height: realH(133),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Transform.translate(
                            offset: Offset(
                                -screenWidth / 3 * (1 - currentExplorePercent),
                                screenWidth /
                                    3 /
                                    2 *
                                    (1 - currentExplorePercent)),
                            child: InkWell(
                              onTap: () {
                                togglePlaceType('fire_station', true);
                                animateExplore(!isExploreOpen);
                              },
                              child: Image.asset(
                                "assets/fire_station.png",
                                width: realH(133),
                                height: realH(133),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Transform.translate(
                            offset: Offset(
                                screenWidth / 3 * (1 - currentExplorePercent),
                                screenWidth /
                                    3 /
                                    2 *
                                    (1 - currentExplorePercent)),
                            child: InkWell(
                              onTap: () {
                                togglePlaceType('doctor', true);
                                animateExplore(!isExploreOpen);
                              },
                              child: Image.asset(
                                "assets/doctor1.png",
                                width: realH(133),
                                height: realH(133),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              togglePlaceType('gas_station', true);
                              animateExplore(!isExploreOpen);
                            },
                            child: Image.asset(
                              "assets/gas_station.png",
                              width: realH(133),
                              height: realH(133),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Transform.translate(
                            offset: Offset(
                                -screenWidth / 3 * (1 - currentExplorePercent),
                                screenWidth /
                                    3 /
                                    2 *
                                    (1 - currentExplorePercent)),
                            child: InkWell(
                              onTap: () {
                                togglePlaceType('dentist', true);
                                animateExplore(!isExploreOpen);
                              },
                              child: Image.asset(
                                "assets/dentist.png",
                                width: realH(133),
                                height: realH(133),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Transform.translate(
                            offset: Offset(
                                screenWidth / 3 * (1 - currentExplorePercent),
                                screenWidth /
                                    3 /
                                    2 *
                                    (1 - currentExplorePercent)),
                            child: InkWell(
                              onTap: () {
                                togglePlaceType('police', true);
                                animateExplore(!isExploreOpen);
                              },
                              child: Image.asset(
                                "assets/POLICE.png",
                                width: realH(133),
                                height: realH(133),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              togglePlaceType('car_repair', true);
                              animateExplore(!isExploreOpen);
                            },
                            child: Image.asset(
                              "assets/car3.png",
                              width: realH(133),
                              height: realH(133),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Padding(
        padding: const EdgeInsets.all(0),
      );
    }
  }

  buildListItem(int index, String name) {
    return Transform.translate(
      offset: Offset(0, index * realH(127) * (1 - currentExplorePercent)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            "assets/banner_${index % 3 + 1}.png",
            width: realH(127),
            height: realH(127),
          ),
          Text(
            placeName[index % 3],
            style: TextStyle(color: Colors.white, fontSize: realH(16)),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
