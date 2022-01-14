import 'package:flutter/cupertino.dart';
import 'package:multi_ads/src/networks/ads.dart';

class CustomBanner extends StatefulWidget {
  final Ads ads;

  const CustomBanner({required Key key, required this.ads}) : super(key: key);

  @override
  _CustomBannerState createState() => _CustomBannerState();
}

class _CustomBannerState extends State<CustomBanner> {
  @override
  void initState() {
    widget.ads.loadBannerAd(() => setState(() {}), widget.key ?? UniqueKey());
    super.initState();
  }

  @override
  void dispose() {
    widget.ads.disposeBanner(widget.key ?? UniqueKey());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.ads.getBannerAdWidget(widget.key ?? UniqueKey());
  }
}
