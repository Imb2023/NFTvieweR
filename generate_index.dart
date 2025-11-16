import 'dart:convert';
import 'dart:io';

void main() async {
  final nftDir = Directory('assets/nfts');
  if (!nftDir.existsSync()) {
    print('❌ Directory not found: assets/nfts');
    exit(1);
  }

  // Define the name and path of the index file we want to exclude from the list
  const indexFileName = 'index.json';
  final indexPathInAssets =
      'nfts/$indexFileName'; // The path format that goes into the JSON list

  // Collect all .json files in the folder (non-recursive)
  final allJsonFiles = nftDir
      .listSync()
      .whereType<File>() // Ensure we are only dealing with File objects
      .where((f) => f.path.endsWith('.json'))
      .toList();

  // Transform file objects into the desired string paths ('nfts/file.json')
  final allFilePaths = allJsonFiles
      .map((f) => f.path.replaceAll('\\', '/').replaceFirst('assets/', ''))
      .toList();

  // Filter the list to exclude the index.json path itself
  final pathsForIndex =
      allFilePaths.where((path) => path != indexPathInAssets).toList();

  // Sort for consistency (optional)
  // pathsForIndex.sort();

  // Write index.json with the filtered list
  final indexFile = File('assets/data/index.json');
  indexFile.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(pathsForIndex));

  print(
      '✅ Generated index.json with ${pathsForIndex.length} entries (excluding itself)');
}
