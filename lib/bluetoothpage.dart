import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/foundation.dart';

class BluetoothMessage {
  final String message;
  final DateTime timestamp;

  BluetoothMessage(this.message, this.timestamp);
}

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({Key? key}) : super(key: key);

  @override
  BluetoothPageState createState() => BluetoothPageState();
}

class BluetoothPageState extends State<BluetoothPage> {
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? _connection;
  List<BluetoothMessage> messages = [];
  List<int> buffer = [];
  bool _isConnected = false;
  final ScrollController _scrollController =
      ScrollController(); // New scroll controller

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  void _initBluetooth() async {
    await _bluetooth.requestEnable(); // Request to enable Bluetooth

    // Auto connect to the specified MAC address if it's not already connected
    if (!_isConnected) {
      await _connectToDevice(
          "98:D3:32:11:0E:13"); // Replace with your desired MAC address
    }
  }

  Future<void> _connectToDevice(String deviceAddress) async {
    try {
      _connection = await BluetoothConnection.toAddress(deviceAddress);
      setState(() {
        _isConnected = true;
      });
      _connection!.input!.listen((Uint8List data) {
        buffer.addAll(data);
        while (buffer.contains('\n'.codeUnitAt(0))) {
          final messageIndex = buffer.indexOf('\n'.codeUnitAt(0));
          final messageBytes = buffer.sublist(0, messageIndex + 1);
          buffer.removeRange(0, messageIndex + 1);
          String message = utf8.decode(messageBytes);
          if (kDebugMode) {
            print("Received message: $message");
          }
          setState(() {
            messages.add(BluetoothMessage(message, DateTime.now()));
          });
          // Scroll to the bottom after adding a message
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print("Error: $error");
      }
      setState(() {
        _isConnected = false;
      });
    }
  }

  void _disconnect() {
    _connection?.close();
    setState(() {
      _isConnected = false;
      messages.clear();
    });
  }

  @override
  void dispose() {
    _connection?.close();
    super.dispose();
  }

  Future<void> _discoverDevices() async {
    try {
      BluetoothDevice? selectedDevice = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return DiscoveryPage(_bluetooth);
          },
        ),
      );

      if (selectedDevice != null) {
        _connectToDevice(selectedDevice.address);
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _isConnected ? 'Connected' : 'Disconnected',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isConnected ? Colors.green : Colors.red,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController, // Add the scroll controller
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(messages[index].message),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 80,
            right: 10,
            child: FloatingActionButton(
              onPressed: () {
                _isConnected ? _disconnect() : _discoverDevices();
              },
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.search_rounded,
                color: Colors.purple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiscoveryPage extends StatefulWidget {
  final FlutterBluetoothSerial bluetooth;

  const DiscoveryPage(this.bluetooth, {Key? key}) : super(key: key);

  @override
  DiscoveryPageState createState() => DiscoveryPageState();
}

class DiscoveryPageState extends State<DiscoveryPage> {
  List<BluetoothDevice> devices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startDiscovery();
  }

  Future<void> _startDiscovery() async {
    try {
      widget.bluetooth.startDiscovery().listen((result) {
        setState(() {
          if (!devices.contains(result.device)) {
            devices.add(result.device);
          }
        });
      }, onDone: () {
        setState(() {
          _isLoading = false;
        });
      }, onError: (error) {
        if (kDebugMode) {
          print("Error: $error");
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print("Error: $error");
      }
    }
  }

  @override
  void dispose() {
    widget.bluetooth.cancelDiscovery();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Bluetooth Devices'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  title: Text(device.name ?? 'Unknown Device'),
                  subtitle: Text(device.address),
                  onTap: () {
                    Navigator.of(context).pop(device);
                  },
                );
              },
            ),
    );
  }
}
