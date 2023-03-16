import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mapbox_demo/app/models/location.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class HomeController extends GetxController {
  PageController pageController = PageController();
  MapboxMap? mapboxMapController;
  RxList<Location> locations = <Location>[].obs;

  // icons
  late Uint8List filledMarker;

  @override
  void onInit() async {
    filledMarker = (await rootBundle.load('assets/location-filled.png'))
        .buffer
        .asUint8List();
    super.onInit();
  }

  void addLayerAndSource() async {
    mapboxMapController?.style
        .styleSourceExists("stations")
        .then((value) async {
      if (!value) {
        var source =
            await rootBundle.loadString('assets/json/cluster_source.json');
        mapboxMapController?.style.addStyleSource("stations", source);
      }
    });

    mapboxMapController?.style.styleLayerExists("clusters").then((value) async {
      if (!value) {
        var layer =
            await rootBundle.loadString('assets/json/cluster_layer.json');
        mapboxMapController?.style.addStyleLayer(layer, null);

        var clusterCountLayer =
            await rootBundle.loadString('assets/json/cluster_count_layer.json');
        mapboxMapController?.style.addStyleLayer(clusterCountLayer, null);

        var unclusteredLayer = await rootBundle
            .loadString('assets/json/unclustered_point_layer.json');
        mapboxMapController?.style.addStyleLayer(unclusteredLayer, null);
      }
    });
  }

  void loadDataOnMap() async {
    mapboxMapController!.annotations
        .createPointAnnotationManager()
        .then((PointAnnotationManager pointAnnotationManager) async {
      var options = <PointAnnotationOptions>[];

      var jsondata =
          await rootBundle.loadString('assets/json/stations.geojson');
      Map<String, dynamic> result = jsonDecode(jsondata);

      for (int i = 0; i < 90; i++) {
        Location location = Location.fromJson(result['features'][i]);
        locations.add(location);
        options.add(PointAnnotationOptions(
          geometry: location.geometry!.toJson(),
          image: filledMarker,
        ));
      }

      // set points on map
      await pointAnnotationManager.createMulti(options);
      pointAnnotationManager.addOnPointAnnotationClickListener(
          AnnotationClickListener(
              mapboxMapController!, pointAnnotationManager));

      // load first location from locations.
      mapboxMapController!.flyTo(
          CameraOptions(
            center: Point(
                    coordinates: Position(
                        locations[0].geometry!.coordinates![0],
                        locations[0].geometry!.coordinates![1]))
                .toJson(),
            zoom: 11,
          ),
          MapAnimationOptions());
    });
  }

  void moveCameraToCurrentPoint(int index) async {
    mapboxMapController!.flyTo(
      CameraOptions(
          zoom: 18,
          center: Point(
                  coordinates: Position(
                      locations[index].geometry!.coordinates![0],
                      locations[index].geometry!.coordinates![1]))
              .toJson()),
      MapAnimationOptions(),
    );
  }
}

class AnnotationClickListener extends OnPointAnnotationClickListener {
  MapboxMap mapboxMapController;
  PointAnnotationManager pointAnnotationManager;
  AnnotationClickListener(
    this.mapboxMapController,
    this.pointAnnotationManager,
  );

  HomeController homeController = Get.find();

  @override
  void onPointAnnotationClick(PointAnnotation annotation) async {
    var data = annotation.geometry!.entries.first.value as List;

    // fly to coordinates
    mapboxMapController.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position(
            data[0],
            data[1],
          ),
        ).toJson(),
        zoom: 18,
      ),
      MapAnimationOptions(),
    );

    int index = homeController.locations.value.indexWhere((element) =>
        element.geometry!.coordinates!.first == data[0] &&
        element.geometry!.coordinates!.last == data[1]);

    homeController.pageController.jumpToPage(index);
  }
}
