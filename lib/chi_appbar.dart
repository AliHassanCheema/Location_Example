import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:stacked/stacked.dart';

class CHIAppBar extends ViewModelBuilderWidget<CHIAppBarVM> {
  final String title;
  final bool search;
  final bool isCross;
  final VoidCallback? onSearch;
  final bool isVisible;
  final VoidCallback? onAction;
  final double? p1;
  final double? p2;
  const CHIAppBar(
    this.title, {
    Key? key,
    this.search = false,
    this.isCross = false,
    this.isVisible = true,
    this.onSearch,
    this.onAction,
    this.p1,
    this.p2,
  }) : super(key: key);
  @override
  Widget builder(BuildContext context, CHIAppBarVM viewModel, Widget? child) {
    return internetIdentifier(viewModel.isConnected);
  }

  @override
  viewModelBuilder(BuildContext context) {
    return CHIAppBarVM();
  }
}

class CHIAppBarVM extends BaseViewModel {
  CHIAppBarVM() {
    connectivityListener();
  }
  bool isConnected = false;
  StreamSubscription<InternetConnectionStatus>? connectivitySubscription;

  void connectivityListener() async {
    InternetConnectionCheckerPlus().addresses =
        NetworkConnectivity.DEFAULT_ADDRESSES;

    connectivitySubscription =
        InternetConnectionCheckerPlus().onStatusChange.listen((status) {
      debugPrint('-----liveInternet-----CHI AppBar-----------------$status');
      switch (status) {
        case InternetConnectionStatus.connected:
          isConnected = true;
          notifyListeners();
          debugPrint(
              '-----liveInternet-----CHI AppBar-----------------connected');
          break;
        case InternetConnectionStatus.disconnected:
          isConnected = false;
          notifyListeners();
          debugPrint(
              '-----liveInternet-----CHI AppBar-----------------disconnected');
          break;
      }
    });
    isConnected = await InternetConnectionCheckerPlus().hasConnection;
    notifyListeners();
  }

  @override
  void dispose() {
    debugPrint('-----liveInternet-----CHI AppBar-----------------dispose');
    if (connectivitySubscription != null) {
      connectivitySubscription!.cancel();
    }
    super.dispose();
  }
}

Widget internetIdentifier(bool status) {
  if (status == true) {
    return const Icon(Icons.wifi, color: Colors.green);
  }
  return const Icon(Icons.wifi_off, color: Colors.red);
}

class NetworkConnectivity {
  static NetworkConnectivity? _instance;

  BuildContext mContext;

  bool isConnected = true;
  StreamSubscription<InternetConnectionStatus>? connectivitySubscription;

  NetworkConnectivity(this.mContext) {
    onCancelSubscription();
    checkState(mContext);
  }

  static NetworkConnectivity get instance => _instance!;

  static NetworkConnectivity create(BuildContext context) {
    _instance = NetworkConnectivity(context);
    return _instance!;
  }

  // static const Duration DEFAULT_TIMEOUT = Duration(seconds: 10);
  // static const int DEFAULT_PORT = 53;
  static const Map<String, String> dnsParameters = {
    'name': 'google.com',
    'type': 'A',
    'dnssec': '1',
  };

  /// The default headers for DNS lookups
  static const Map<String, String> dnsHeaders = {
    'Accept': 'application/dns-json',
    'Cache-Control': 'no-cache',
    'Content-Type': 'application/json',
  };

  static final List<AddressCheckOptions> DEFAULT_ADDRESSES = [
    AddressCheckOptions(
      Uri.parse('https://www.google.com/').replace(
        queryParameters: dnsParameters,
      ),
      headers: dnsHeaders,
    ),
    AddressCheckOptions(
      Uri.parse('https://www.cognitivehealthintl.com').replace(
        queryParameters: dnsParameters,
      ),
      headers: dnsHeaders,
    ),
    AddressCheckOptions(
      Uri.parse('https://cloudflare-dns.com/dns-query').replace(
        queryParameters: dnsParameters,
      ),
      headers: dnsHeaders,
    ),
    AddressCheckOptions(
      Uri.parse('https://mozilla.cloudflare-dns.com/dns-query').replace(
        queryParameters: dnsParameters,
      ),
      headers: dnsHeaders,
    ),
  ];

  void checkState(BuildContext context) async {
    InternetConnectionCheckerPlus().addresses = DEFAULT_ADDRESSES;

    connectivitySubscription =
        InternetConnectionCheckerPlus().onStatusChange.listen((status) {
      debugPrint('-----------NetworkConnectivity---- Stream---> $status');
      switch (status) {
        case InternetConnectionStatus.connected:
          isConnected = true;
          debugPrint('-----------NetworkConnectivity----- Stream--> connected');
          break;
        case InternetConnectionStatus.disconnected:
          isConnected = false;
          debugPrint(
              '-----------NetworkConnectivity----- Stream--> disconnected');
          break;
      }
    });

    isConnected = await InternetConnectionCheckerPlus().hasConnection;
  }

  StreamSubscription<InternetConnectionStatus>? checkLiveInternet() {
    return connectivitySubscription;
  }

  Future<bool> isInternetConnected() async {
    debugPrint('-----------NetworkConnectivity----- isInternetConnected--');
    return await InternetConnectionCheckerPlus().hasConnection;
  }

  bool isInternetConnectedResult(InternetConnectionStatus result) {
    debugPrint(
        '-----------NetworkConnectivity----- isInternetConnectedResult-- $result');
    var checkConnection = true;
    switch (result) {
      case InternetConnectionStatus.connected:
        checkConnection = true;
        debugPrint(
            '-----------NetworkConnectivity----- isInternetConnectedResult-- connected');
        break;
      case InternetConnectionStatus.disconnected:
        checkConnection = false;
        debugPrint(
            '-----------NetworkConnectivity----- isInternetConnectedResult-- disconnected');
        break;
    }

    return checkConnection;
  }

  onCancelSubscription() {
    if (connectivitySubscription != null) {
      connectivitySubscription!.cancel();
    }
  }
}
