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
  final ScrollController _scrollController = ScrollController();

  List<Nft> _allNfts = [];
  List<Nft> _visibleNfts = [];
  bool _loadingMore = false;

  final int _batchSize = 20;

  @override
  void initState() {
    super.initState();
    _loadInitial();
    _scrollController.addListener(_handleScroll);
  }

  Future<void> _loadInitial() async {
    final loaded = await _service.loadLocalNfts();
    _allNfts = loaded;

    // Load the first batch
    final initialBatch = _allNfts.take(_batchSize).toList();

    setState(() {
      _visibleNfts = initialBatch;
    });
  }

  void _handleScroll() {
    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore) return;
    if (_visibleNfts.length >= _allNfts.length) return;

    setState(() => _loadingMore = true);

    // Slight delay to mimic loading and prevent hammering UI
    await Future.delayed(const Duration(milliseconds: 200));

    final start = _visibleNfts.length;
    final end = (start + _batchSize).clamp(0, _allNfts.length);

    final nextBatch = _allNfts.sublist(start, end);

    setState(() {
      _visibleNfts.addAll(nextBatch);
      _loadingMore = false;
    });
  }

  int _columnCount(double width) {
    if (width >= 2000) return 5;
    if (width >= 1400) return 4;
    if (width >= 1000) return 3;
    return 2; // mobile & small screens
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NFT Showcase")),
      body: _allNfts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final columns = _columnCount(constraints.maxWidth);

                return GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _visibleNfts.length + 1,
                  itemBuilder: (context, index) {
                    // Loading indicator at the bottom
                    if (index == _visibleNfts.length) {
                      return _loadingMore
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox.shrink();
                    }

                    return NftCard(nft: _visibleNfts[index]);
                  },
                );
              },
            ),
    );
  }
}
