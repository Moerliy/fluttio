import 'package:flutter/material.dart';
import 'package:fluttio/providers/gyro_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Consumer<GyroProvider>(
          builder: (context, prov, child) {
            return Center(
              child: ElevatedButton(
                onPressed: prov.switching ? null : prov.toggleProvider,
                child: prov.switching
                    ? const CircularProgressIndicator()
                    : Text(prov.useESense
                        ? 'Switch to Device Gyro'
                        : 'Switch to eSense Gyro'),
              ),
            );
          },
        ));
  }
}
