import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter/DataClasses/SearchLocalityClass.dart';
import 'package:localport_alter/resources/MyColors.dart';
import 'package:localport_alter/services/location_locality_service.dart';
import 'package:localport_alter/services/places_search_service.dart';
import 'package:localport_alter/widgets/Skeletons/LocalitySearchPageSkeleton.dart';
import 'package:provider/provider.dart';

class LocalitySearchPage extends StatefulWidget {
  @override
  LocalitySearchPageState createState() => LocalitySearchPageState();
}

class LocalitySearchPageState extends State<LocalitySearchPage> {
  Widget SearchBar() {
    return Consumer<LocationLocalityService>(
        builder: (context, snapshot, child) {
      Map<String, dynamic> _locality = snapshot.getLocality();
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 12, offset: Offset(0, -1))
        ]),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: TextField(
            onChanged: (val) {
              Provider.of<PlacesSearchService>(context, listen: false)
                  .searchPlace(val, _locality['lat'], _locality['long']);
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search locality. eg. civil lines...",
                prefixIcon: Icon(Icons.search)),
          ),
        ),
      );
    });
  }

  nearByResults() {
    return Consumer<LocationLocalityService>(
        builder: (context, snapshot, child) {
      List<SearchLocalityClass> _nearbyPlaceList =
          snapshot.getNearbyLocationList();
      return _nearbyPlaceList.length == 0
          ? LocalitySearchPageSkeleton()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Nearby Locations",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                    itemCount: _nearbyPlaceList.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                                   return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context, _nearbyPlaceList[index]);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            child: ListTile(
                              title: Text(
                                _nearbyPlaceList[index].main_text,
                                style: TextStyle(),
                              ),
                              subtitle:
                                  Text(_nearbyPlaceList[index].secondary_text),
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            );
    });
  }

  textSearchResults() {
    return Consumer<PlacesSearchService>(builder: (context, snapshot, child) {
      List<SearchLocalityClass> _textSearchList = snapshot.getPredictions();
      return _textSearchList.length == 0
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Search Result",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                    itemCount: _textSearchList.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context, _textSearchList[index]);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            child: ListTile(
                              title: Text(
                                _textSearchList[index].main_text,
                                style: TextStyle(),
                              ),
                              subtitle: Text(
                                  "${_textSearchList[index].secondary_text}"),
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            );
    });
  }

  @override
  void initState() {
    super.initState();
    //
    // Provider.of<LocationLocalityService>(context, listen: false)
    //     .fetchLocality(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color1,
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color:Colors.white,
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              children: [SearchBar(),
                // nearByResults(),
                textSearchResults()],
            ),
          ],
        ),
      )),
    );
  }
}
