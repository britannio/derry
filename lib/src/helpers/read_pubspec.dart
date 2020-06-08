part of derry;

/// read and return yaml document
Future<YamlDocument> readYamlFile(String filePath) async {
  final file = File(filePath);
  YamlDocument document;

  if (!await file.exists()) {
    throw 'File not found at $filePath';
  }

  try {
    document = loadYamlDocument(await file.readAsString());
  } catch (e) {
    throw 'YAML File can\'t be parsed';
  }

  return document;
}

/// read and return pubspec.yaml in current directory
Future<YamlDocument> readPubspec() async {
  return readYamlFile(Directory.current.path + '/pubspec.yaml');
}
