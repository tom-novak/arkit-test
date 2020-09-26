import 'dart:async';

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ARKitController arKitController;
  Timer timer;

  @override
  void dispose() {
    timer?.cancel();
    arKitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ARKitSceneView(
        detectionImagesGroupName: 'AR Resources',
        onARKitViewCreated: _onARKitViewCreated,
      ),
    );
  }

  void _onARKitViewCreated(ARKitController arKitController) {
    this.arKitController = arKitController;
    this.arKitController.onAddNodeForAnchor = _onAddNodeForAnchor;
  }

  void _onAddNodeForAnchor(ARKitAnchor arKitAnchor) {
    if (arKitAnchor is ARKitImageAnchor) {
      final position = arKitAnchor.transform.getColumn(3);

      final material = ARKitMaterial(
        lightingModelName: ARKitLightingModel.lambert,
        diffuse: ARKitMaterialProperty(image: 'assets/earth.jpg'),
      );

      final sphere = ARKitSphere(
        materials: [material],
        radius: 0.1,
      );
      final node = ARKitNode(
        geometry: sphere,
        position: Vector3(position.x, position.y, position.z),
        eulerAngles: Vector3.zero(),
      );
      this.arKitController.add(node);

      /*timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        final rotation = node.eulerAngles;
        rotation.x += 0.01;
        node.eulerAngles = rotation;
      });*/
    }
  }
}
