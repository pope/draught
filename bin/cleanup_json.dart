import 'dart:convert' show JSON;
import 'dart:io';
import "package:path/path.dart" show dirname;

List<Map> tierPlayers(Map data) {
  var clusters = data['clusters'];
  return data['rankings'].values.expand((i) => i).map((e) {
    var cluster = e.remove('Cluster');
    var clusterPos = clusters[e['Position']];
    var tier = clusterPos.indexOf(
      clusterPos.firstWhere((c) => c['Cluster'] == cluster)) + 1;
    return e..['Tier'] = tier;
  }).toList();
}

void main() {
  var scriptDir = dirname(Platform.script.toFilePath());
  var input = '$scriptDir/2014-draft-info.json';
  var output = '$scriptDir/../web/2014-draft-info.json';
  new File(input).readAsString()
      .then(JSON.decode)
      .then(tierPlayers)
      .then((d) => d..sort((a, b) => a['Rank'] - b['Rank']))
      .then(JSON.encode)
      .then((d) => new File(output).writeAsString(d));
}
