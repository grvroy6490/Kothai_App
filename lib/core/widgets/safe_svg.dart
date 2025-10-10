import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';

/// Loads an SVG asset and strips unsupported elements/tags (e.g., <filter>, <foreignObject>)
/// that commonly trigger flutter_svg warnings like:
///  - unhandled element <foreignObject/>
///  - unhandled element <filter/>
/// Falls back to an empty SizedBox while loading.
class SafeSvgAsset extends StatelessWidget {
    final String asset;
    final double? width;
    final double? height;
    final BoxFit fit;
    final Alignment alignment;
    final ColorFilter? colorFilter;

    const SafeSvgAsset(
        this.asset, {
            super.key,
            this.width,
            this.height,
            this.fit = BoxFit.contain,
            this.alignment = Alignment.center,
            this.colorFilter
        });

    String _cleanSvg(String raw) {
        // Remove <filter> blocks entirely
        var s = raw.replaceAll(RegExp(r"<\s*filter[\s\S]*?<\s*/\s*filter\s*>", multiLine: true), "");
        // Remove <foreignObject> blocks entirely
        s = s.replaceAll(RegExp(r"<\s*foreignObject[\s\S]*?<\s*/\s*foreignObject\s*>", multiLine: true), "");
        // Remove references to filters: filter="url(#id)" and style="filter:..."
        s = s.replaceAll(RegExp(r'\sfilter="[^"]*"'), "");
        s = s.replaceAll(RegExp(r'filter:[^;"\s]*;?'), "");
        return s;
    }

    @override
    Widget build(BuildContext context) {
        return FutureBuilder<String>(
            future: rootBundle.loadString(asset),
            builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData) {
                    return SizedBox(width: width, height: height);
                }
                final cleaned = _cleanSvg(snapshot.data!);
                return SvgPicture.string(
                    cleaned,
                    width: width,
                    height: height,
                    fit: fit,
                    alignment: alignment,
                    colorFilter: colorFilter
                );
            }
        );
    }
}

