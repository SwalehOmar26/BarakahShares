import 'package:flutter/material.dart';

enum BrandMark { emblem, lockup, icon }

/// Official BarakahShares artwork cropped from the brand sheets.
/// The emblem is the crescent, arch, bars, and leaves. The lockup is the
/// full horizontal logo for light backgrounds.
class BrandLogo extends StatelessWidget {
  const BrandLogo({this.size = 96, this.variant = BrandMark.emblem, super.key});

  final double size;
  final BrandMark variant;

  String get _asset {
    return switch (variant) {
      BrandMark.emblem => 'assets/brand/logo_mark.png',
      BrandMark.lockup => 'assets/brand/logo_lockup_light.png',
      BrandMark.icon => 'assets/brand/app_icon.png',
    };
  }

  @override
  Widget build(BuildContext context) {
    final lockup = variant == BrandMark.lockup;
    return Image.asset(
      _asset,
      width: size,
      height: lockup ? null : size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      semanticLabel: 'BarakahShares logo',
    );
  }
}
