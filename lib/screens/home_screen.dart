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

  int _columnCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 2000) return 5;
    if (width >= 1400) return 4;
    if (width >= 1000) return 3;
    return 2; // phones + small screens
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NFT Showcase")),
      body: FutureBuilder<List<Nft>>(
        future: _nfts,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final nfts = snapshot.data!;

          return LayoutBuilder(
            builder: (context, constraints) {
              final columns = _columnCount(context);

              return GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: nfts.length,
                itemBuilder: (context, i) => NftCard(nft: nfts[i]),
              );
            },
          );
        },
      ),
    );
  }
}
