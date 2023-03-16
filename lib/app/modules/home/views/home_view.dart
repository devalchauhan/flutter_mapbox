import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mapbox_demo/app/models/location.dart';

import '../controllers/home_controller.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MapBox'),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // MapboxMap(mapboxMapsPlatform: mapboxMapsPlatform),
          MapWidget(
            onTapListener: (coordinate) async {
              final ScreenCoordinate conv =
                  await controller.mapboxMapController!.pixelForCoordinate(
                Point(
                  coordinates: Position(
                    coordinate.y,
                    coordinate.x,
                  ),
                ).toJson(),
              );

              final List<QueriedFeature?> features =
                  await controller.mapboxMapController!.queryRenderedFeatures(
                RenderedQueryGeometry(
                  value: jsonEncode(conv.encode()),
                  type: Type.SCREEN_COORDINATE,
                ),
                RenderedQueryOptions(),
              );

              print(features.first!.feature.entries);
            },
            resourceOptions: ResourceOptions(
              accessToken:
                  'pk.eyJ1IjoiZGV2YWxjIiwiYSI6ImNsZjd0NzI3MzA3aXQzdW8yZTA2ZDhhaWQifQ.0_ylBpj0V-cltc7Ga-zBog',
            ),
            onMapCreated: (ctrl) {
              controller.mapboxMapController = ctrl;

              controller.loadDataOnMap();
              controller.addLayerAndSource();
            },
          ),

          //
          SafeArea(
            child: SizedBox(
              height: 100,
              child: Obx(() => PageView.builder(
                    controller: controller.pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.locations.length,
                    // padding: const EdgeInsets.symmetric(horizontal: 8),
                    physics: const PageScrollPhysics(),

                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: Get.width * .95,
                        child: Card(
                          // elevation: 8,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller
                                      .locations[index].properties!.title!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  controller
                                      .locations[index].properties!.address!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    onPageChanged: (index) {
                      controller.moveCameraToCurrentPoint(index);
                    },
                  )),
            ),
          )
        ],
      ),
    );
  }
}
