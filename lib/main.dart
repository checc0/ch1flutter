// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'Ch1AppGQLoader.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:developer';
import 'heroesCarousel.dart';
import 'dart:async';
import 'SettingsWidget.dart';
import 'fonts/meFontMap.dart';
import 'pageView.dart';

// Portal cloud: https://portal.sitecorecloud.io/
// Content hub one: https://content.sitecorecloud.io/?tenantName=hc-sales-12-ea-f1094
//
// Graphql Playground https://content-api.sitecorecloud.io/api/content/v1/preview/graphql/ide/
//
// {
//   "X-GQL-Token":"SmNmakFPVXlzUzAxRzkrR0E2bjBjQ3ZJL3d3Sk5OUTdkNlFsRGtCSUxpZz18aGMtc2FsZXMtMTItZWEtZjEwOTQ="
// }

void main() async {
  runApp(Ch1AppGQLoader(applicationBuilder: (node, updateFunction) {
    return MaterialApp(
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
        debugShowCheckedModeBanner: false,
        home: Ch1App(appRoot: node, updateResults: updateFunction));
  }));
}

//
// Build  Material App from a map object of the json app
//
class Ch1App extends StatefulWidget {
  final Map appRoot;
  final Function updateResults;

  const Ch1App({super.key, required this.appRoot, required this.updateResults});

  @override
  _Ch1App createState() => _Ch1App();
}

//
// Create the materialapp
//
class _Ch1App extends State<Ch1App> {
  // Whether the toolbar should be visible.
  bool _visibleToolbar = true;
  final int inactivityTimeOutMs = 250;
  final int animDurationMS = 250;
  Timer? inactivityTimer;

  int _selectedMenuItem = 0;

  // This will handle inactivity of the user, if the user inactive for
  // inactivityTimeOutMs millisecond then set the visibility of the toolbar false
  void _handleUpEvent(PointerUpEvent event) {
    inactivityTimer?.cancel();

    inactivityTimer = Timer(Duration(milliseconds: inactivityTimeOutMs), () {
      if (mounted) {
        setState(() {
          _visibleToolbar = true;
        });
      }
    });
  }

  // Hide the toolbar if the user is interacting with the home page
  void _handleDownEvent(PointerDownEvent event) {
    inactivityTimer?.cancel();

    if (mounted) {
      setState(() {
        _visibleToolbar = false;
      });
    }
  }

  // Provide a Material icon given a name, a default error icon will returned
  // if iconName isn't found
  Icon _IconFromLabel(String iconName) {
    return Icon(IconData(maFontsMap[iconName]?['codepoint'] ?? 0xe237,
        fontFamily: maFontsMap[iconName]?['fontfamily'] ?? "MaterialIcons",
        matchTextDirection: true));
  }

  // Create dinamic menu items, adding the default home button
  List<BottomNavigationBarItem> _createNavigationMenu(List menuItems) {
    List<BottomNavigationBarItem> menuItemsGenerated = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
    ];

    menuItemsGenerated.addAll(menuItems
        .map((item) => BottomNavigationBarItem(
              icon: _IconFromLabel(item['materialIconName']),
              label: item['title'],
            ))
        .toList());

    return menuItemsGenerated;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            floatingActionButton: AnimatedOpacity(
                // If the widget is visible, animate to 0.0 (invisible).
                // If the widget is hidden, animate to 1.0 (fully visible).
                opacity: _selectedMenuItem == 0
                    ? (_visibleToolbar ? 1.0 : 0.0)
                    : 1.0,
                duration: Duration(milliseconds: animDurationMS),
                // The green box must be a child of the AnimatedOpacity widget.
                child: _selectedMenuItem == 0
                    ? FloatingActionButton(
                        elevation: 0.0,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                          );
                        },
                        backgroundColor: const Color(0x00000000),
                        foregroundColor: const Color(0x20000000),
                        child: const Icon(
                          Icons.settings,
                          size: 38,
                        ),
                      )
                    : null),
            extendBody: _selectedMenuItem == 0,
            bottomNavigationBar: AnimatedOpacity(
                // If the widget is visible, animate to 0.0 (invisible).
                // If the widget is hidden, animate to 1.0 (fully visible).
                opacity: _selectedMenuItem == 0
                    ? (_visibleToolbar ? 1.0 : 0.0)
                    : 1.0,
                duration: Duration(milliseconds: animDurationMS),
                // The green box must be a child of the AnimatedOpacity widget.
                child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _selectedMenuItem,
                    onTap: (value) {
                      setState(() {
                        _selectedMenuItem = value;
                      });
                      print(value);
                    },
                    backgroundColor: const Color(0xa0000000),
                    items: _createNavigationMenu(
                        widget.appRoot['sections']['results']))),
            body: RefreshIndicator(
                color: Colors.white,
                backgroundColor: Colors.blue,
                onRefresh: () async {
                  //  Call the application reload function
                  widget.updateResults();
                },

                // The listner is used to hide the toolbar when there is no activity on the view
                child: Listener(
                    onPointerUp: _handleUpEvent,
                    onPointerDown: _handleDownEvent,
                    // Show home page or page content if selected
                    child: _selectedMenuItem == 0
                        ? heroesCarousel(
                            heroList: widget.appRoot['heroes']['results'])
                        : pageView(
                            page: widget.appRoot['sections']['results']
                                [_selectedMenuItem - 1])))));
  }
}
