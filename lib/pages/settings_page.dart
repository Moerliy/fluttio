import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttio/models/theme.dart';
import 'package:fluttio/providers/gyro_provider.dart';
import 'package:fluttio/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Map<Flavor, String> flavorNames = {
    catppuccin.latte: 'Latte',
    catppuccin.frappe: 'Frappe',
    catppuccin.macchiato: 'Macchiato',
    catppuccin.mocha: 'Mocha',
  };
  @override
  Widget build(BuildContext context) {
    return Consumer2<GyroProvider, SettingsProvider>(
        builder: (context, gyroProvider, settingsProvider, child) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: getColorMap(settingsProvider.themeFlavor)["text"]),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: ListView(
            children: [
              _buildSection([
                _buildTile(
                  title: gyroProvider.useESense
                      ? 'Using ESense Gyro'
                      : 'Using Device Gyro',
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          getColorMap(settingsProvider.themeFlavor)["overlay0"],
                      disabledBackgroundColor:
                          getColorMap(settingsProvider.themeFlavor)["surface0"],
                    ),
                    onPressed: gyroProvider.switching
                        ? null
                        : () => gyroProvider.toggleProvider(settingsProvider
                            .themeFlavor), // Replace `true` with the desired argument
                    child: gyroProvider.switching
                        ? CircularProgressIndicator(
                            color: getColorMap(
                                settingsProvider.themeFlavor)["mauve"])
                        : Text(
                            "Switch",
                            style: TextStyle(
                                color: getColorMap(
                                    settingsProvider.themeFlavor)["text"]),
                          ),
                  ),
                  leadingIcon: Icons.gps_fixed,
                ),
              ]),
              _buildSection([
                _buildTile(
                  title: "Theme",
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 0),
                    decoration: BoxDecoration(
                      color:
                          getColorMap(settingsProvider.themeFlavor)["surface0"],
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: getColorMap(
                            settingsProvider.themeFlavor)["overlay0"]!,
                        width: 2.0,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Flavor>(
                        value: settingsProvider.themeFlavor,
                        dropdownColor:
                            getColorMap(settingsProvider.themeFlavor)["base"],
                        onChanged: (Flavor? newFlavor) {
                          if (newFlavor != null) {
                            settingsProvider.setThemeFlavor(newFlavor);
                          }
                        },
                        items: flavorNames.keys.map((Flavor flavor) {
                          return DropdownMenuItem<Flavor>(
                            value: flavor,
                            child: Text(
                              flavorNames[flavor]!,
                              style: TextStyle(
                                color: getColorMap(
                                    settingsProvider.themeFlavor)["text"],
                              ),
                            ),
                          );
                        }).toList(),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color:
                              getColorMap(settingsProvider.themeFlavor)["text"],
                        ),
                      ),
                    ),
                  ),
                  leadingIcon: Icons.color_lens,
                ),
              ])
            ],
          ));
    });
  }

  Widget _buildTile({
    required String title,
    String? subtitle,
    Widget? trailing,
    required IconData leadingIcon,
    VoidCallback? onTap,
  }) {
    return Container(
      child: Consumer<SettingsProvider>(
          builder: (context, settingsProvider, child) {
        return ListTile(
          title: Text(title, style: const TextStyle(fontSize: 16)),
          subtitle: subtitle != null ? Text(subtitle) : null,
          leading: Icon(leadingIcon,
              color: getColorMap(settingsProvider.themeFlavor)["mauve"]),
          trailing: trailing ?? const Icon(Icons.chevron_right),
          onTap: onTap,
        );
      }),
    );
  }

  Widget _buildSection(List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tiles,
    );
  }
}
