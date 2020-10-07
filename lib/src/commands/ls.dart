part of derry;

/// the `derry ls` command
class ListCommand extends Command {
  @override
  String get name => 'ls';

  @override
  String get description => 'list available scripts in the current config';

  @override
  Future<void> run() async {
    final info = await loadInfo();
    final infoLine = '+ ${info.name}@${info.version}';
    final definitions = await loadDefinitions();
    final keys = makeKeys(definitions)..sort();

    final mapping = Map.fromEntries(
      keys
          .asMap()
          .entries
          .map(
            (entry) => MapEntry(
              entry.key,
              parseDefinition(search(definitions, entry.value)),
            ),
          )
          .map(
            (entry) => MapEntry(
              entry.key,
              entry.value.scripts.where((s) => s.startsWith('\$')).toList(),
            ),
          ),
    );

    print(infoLine);
    print('│');

    for (final entry in keys.asMap().entries) {
      final i = entry.key;
      final value = entry.value;
      final subcommands = mapping[entry.key];

      print('${getPrefix(i, keys.length)} $value');

      for (final subEntry in subcommands.asMap().entries) {
        final j = subEntry.key;
        final subValue = format(
          '{color.green}${subEntry.value.replaceAll('\\\$', '\$').split(':').join(' ')}{color.end}',
        );

        print(
            '${i == keys.length - 1 ? ' ' : '│'}   ${getPrefix(j, subcommands.length)} $subValue');
      }
    }
  }

  String getPrefix(int current, int len) {
    return current == len - 1 ? '└──' : '├──';
  }
}
