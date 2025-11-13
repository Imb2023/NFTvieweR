import 'package:flutter/material.dart';
import '../core/models/nft_model.dart';

class NftAttributeChip extends StatelessWidget {
  final NftAttribute attr;

  const NftAttributeChip({super.key, required this.attr});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('${attr.traitType}: ${attr.value}'),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}
