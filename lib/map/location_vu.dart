

import 'package:flutter/material.dart';
import 'package:location_example/map/location_vm.dart';
import 'package:stacked/stacked.dart';

class LocationScreen extends ViewModelBuilderWidget<LocationViewModel> {
  const LocationScreen({super.key});

  @override
  Widget builder(BuildContext context, LocationViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Location Example'),
      ),
      body: Center(
        child:
        viewModel.isBusy ? const CircularProgressIndicator(color: Colors.green,) :
         Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(viewModel.address),
          )),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        viewModel.getAddressFromLatLong();
      },
      child: const Icon(Icons.location_on),
    ));
  }

  @override
  LocationViewModel viewModelBuilder(BuildContext context) {
    return LocationViewModel();
  }

}