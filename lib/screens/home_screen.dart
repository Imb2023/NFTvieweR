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

  bool _loadingInitial = true;
  bool _loadingMore = false;

  /// Increase these for smoother UX on desktop screens
  final int _initialBatchSize = 60;
  final int _batchSize = 30;

  @override
  void initState() {
    super.initState();
    _loadInitial();
    _scrollController.addListener(_handleScroll);
  }

  Future<void> _loadInitial() async {
    setState(() {
      _loadingInitial = true;
      _visibleNfts.clear();
    });

    final loaded = await _service.loadLocalNfts();
    _allNfts = loaded;

    final first = _allNfts.take(_initialBatchSize).toList();

    if (!mounted) return;
    setState(() {
      _visibleNfts = first;
      _loadingInitial = false;
    });
  }

  void _handleScroll() {
    final position = _scrollController.position;

    /// Trigger load when user reaches 90% of bottom
    if (!_loadingMore &&
        _visibleNfts.length < _allNfts.length &&
        position.pixels > position.maxScrollExtent * 0.9) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore) return;
    if (_visibleNfts.length >= _allNfts.length) return;

    setState(() => _loadingMore = true);

    await Future.delayed(const Duration(milliseconds: 180)); // UI smoothness

    final start = _visibleNfts.length;
    final end = (start + _batchSize).clamp(0, _allNfts.length);

    final next = _allNfts.sublist(start, end);

    if (!mounted) return;
    setState(() {
      _visibleNfts.addAll(next);
      _loadingMore = false;
    });
  }

  int _columnCount(double width) {
    if (width >= 2000) return 5;
    if (width >= 1400) return 4;
    if (width >= 1000) return 3;
    return 2;
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

      /// Pull-to-refresh for all platforms
      body: RefreshIndicator(
        onRefresh: _loadInitial,
        child: _loadingInitial
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
          builder: (context, constraints) {
            final columns = _columnCount(constraints.maxWidth);

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverGrid(
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        return NftCard(nft: _visibleNfts[index]);
                      },
                      childCount: _visibleNfts.length,
                    ),
                  ),
                ),

                /// Bottom loading indicator
                SliverToBoxAdapter(
                  child: _loadingMore
                      ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
