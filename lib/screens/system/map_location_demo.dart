import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// 地图定位演示 - 使用系统地图应用
class MapLocationDemo extends StatefulWidget {
  const MapLocationDemo({super.key});

  @override
  State<MapLocationDemo> createState() => _MapLocationDemoState();
}

class _MapLocationDemoState extends State<MapLocationDemo> {
  // 预设的一些常用位置
  final List<LocationItem> _locations = [
    LocationItem(
      name: '北京天安门',
      latitude: 39.9042,
      longitude: 116.4074,
      icon: Icons.account_balance,
    ),
    LocationItem(name: '上海东方明珠', latitude: 31.2397, longitude: 121.4994, icon: Icons.location_city),
    LocationItem(name: '深圳腾讯大厦', latitude: 22.5408, longitude: 114.0542, icon: Icons.business),
    LocationItem(name: '杭州西湖', latitude: 30.2430, longitude: 120.1393, icon: Icons.water),
    LocationItem(name: '广州塔', latitude: 23.1087, longitude: 113.3190, icon: Icons.flag),
  ];

  LocationItem? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('地图定位'), backgroundColor: colorScheme.surfaceContainer),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 说明卡片
          Card(
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: colorScheme.onPrimaryContainer),
                      const SizedBox(width: 8),
                      Text(
                        '地图功能说明',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '此演示使用系统级地图应用查看位置。\n'
                    '点击位置卡片可在地图中查看，长按可复制坐标。',
                    style: TextStyle(color: colorScheme.onPrimaryContainer),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 当前选中位置
          if (_selectedLocation != null) ...[
            Card(
              color: colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '当前选中位置',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSecondaryContainer.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _selectedLocation!.icon,
                          color: colorScheme.onSecondaryContainer,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedLocation!.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSecondaryContainer,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '纬度: ${_selectedLocation!.latitude.toStringAsFixed(4)}',
                                style: TextStyle(color: colorScheme.onSecondaryContainer),
                              ),
                              Text(
                                '经度: ${_selectedLocation!.longitude.toStringAsFixed(4)}',
                                style: TextStyle(color: colorScheme.onSecondaryContainer),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 位置列表
          Text(
            '预设位置',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ..._locations.map((location) => _buildLocationCard(location, colorScheme)),
        ],
      ),
    );
  }

  Widget _buildLocationCard(LocationItem location, ColorScheme colorScheme) {
    final isSelected = _selectedLocation?.name == location.name;

    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? colorScheme.tertiaryContainer : colorScheme.surfaceContainerHighest,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() {
            _selectedLocation = location;
          });
          _openInMap(location);
        },
        onLongPress: () {
          HapticFeedback.mediumImpact();
          _copyCoordinates(location);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.onTertiaryContainer.withOpacity(0.1)
                      : colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  location.icon,
                  color: isSelected
                      ? colorScheme.onTertiaryContainer
                      : colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? colorScheme.onTertiaryContainer : colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isSelected
                            ? colorScheme.onTertiaryContainer.withOpacity(0.7)
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.map,
                color: isSelected ? colorScheme.onTertiaryContainer : colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openInMap(LocationItem location) async {
    final url = Uri.parse(
      'geo:${location.latitude},${location.longitude}?q=${location.latitude},${location.longitude}(${Uri.encodeComponent(location.name)})',
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        // 如果 geo: 不支持，尝试使用 Google Maps URL
        final googleMapsUrl = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}',
        );
        if (await canLaunchUrl(googleMapsUrl)) {
          await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
        } else {
          _showSnackBar('无法打开地图应用');
        }
      }
    } catch (e) {
      _showSnackBar('打开地图失败: $e');
    }
  }

  void _copyCoordinates(LocationItem location) {
    final coordinates = '${location.latitude},${location.longitude}';
    Clipboard.setData(ClipboardData(text: coordinates));
    _showSnackBar('坐标已复制: $coordinates');
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
  }
}

class LocationItem {
  final String name;
  final double latitude;
  final double longitude;
  final IconData icon;

  LocationItem({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.icon,
  });
}
