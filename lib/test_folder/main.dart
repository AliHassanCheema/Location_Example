import 'package:flutter/material.dart';
import 'package:locateme/test_folder/test_vm.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  return runApp(const GaugeApp());
}

class GaugeApp extends StatelessWidget {
  const GaugeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radial Gauge Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TestScreen(),
    );
  }
}

class TestScreen extends ViewModelBuilderWidget<TestViewModel> {
  const TestScreen({Key? key}) : super(key: key);
  @override
  Widget builder(BuildContext context, TestViewModel viewModel, Widget? child) {
    return Scaffold(
        appBar: AppBar(title: const Text('Syncfusion Flutter Gauge')),
        body: Column(
          children: [
            getGauge(viewModel),
            ElevatedButton(
                onPressed: () {
                  viewModel.onUpdateValue();
                },
                child: const Text('Update'))
          ],
        ));
  }

  @override
  TestViewModel viewModelBuilder(BuildContext context) {
    final vm = TestViewModel();
    return vm;
  }
}

Widget getGauge(TestViewModel viewModel, {bool isRadialGauge = true}) {
  if (isRadialGauge) {
    return getRadialGauge(viewModel);
  } else {
    return getLinearGauge();
  }
}

Widget getRadialGauge(TestViewModel viewModel) {
  return SfRadialGauge(
      title: const GaugeTitle(
          text: 'Speedometer',
          textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      axes: <RadialAxis>[
        RadialAxis(minimum: 0, maximum: 150, ranges: <GaugeRange>[
          GaugeRange(
              startValue: 0,
              endValue: 50,
              color: Colors.green,
              startWidth: 10,
              endWidth: 10),
          GaugeRange(
              startValue: 50,
              endValue: 100,
              color: Colors.orange,
              startWidth: 10,
              endWidth: 10),
          GaugeRange(
              startValue: 100,
              endValue: 150,
              color: Colors.red,
              startWidth: 10,
              endWidth: 10)
        ], pointers: <GaugePointer>[
          NeedlePointer(value: viewModel.valuee)
        ], annotations: <GaugeAnnotation>[
          GaugeAnnotation(
              widget: Text(viewModel.valuee.toString(),
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)),
              angle: 90,
              positionFactor: 0.5)
        ])
      ]);
}

Widget getLinearGauge() {
  return Container(
    margin: const EdgeInsets.all(10),
    child: SfLinearGauge(
        minimum: 0.0,
        maximum: 100.0,
        orientation: LinearGaugeOrientation.horizontal,
        majorTickStyle: const LinearTickStyle(length: 20),
        axisLabelStyle: const TextStyle(fontSize: 12.0, color: Colors.black),
        axisTrackStyle: const LinearAxisTrackStyle(
            color: Colors.cyan,
            edgeStyle: LinearEdgeStyle.bothFlat,
            thickness: 15.0,
            borderColor: Colors.grey)),
  );
}
