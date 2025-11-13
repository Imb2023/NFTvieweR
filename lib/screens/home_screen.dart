import 'package:flutter/material.dart';
import '../core/models/nft_model.dart';
import '../core/services/nft_service.dart';
import '../widgets/nft_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NftService _service = NftService();
  late Future<List<Nft>> _nfts;

  @override
  void initState() {
    super.initState();
    _nfts = _service.loadLocalNfts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NFT showcase")),
      body: FutureBuilder<List<Nft>>(
        future: _nfts,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final nfts = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: nfts.length,
            itemBuilder: (context, i) => NftCard(nft: nfts[i]),
          );
        },
      ),
    );
  }
}
