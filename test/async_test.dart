import 'package:unittest/unittest.dart';
import 'dart:async';
import 'package:ffapp/async.dart';
import 'package:unittest/vm_config.dart';

main() {
  useVMConfiguration();

  group('StreamOfStreams', () {
    test('listen', () {
      StreamController<String> textA = new StreamController<String>();
      StreamController<String> textB = new StreamController<String>();
      Stream<String> underTest = new StreamOfStreams<String>([textA.stream,
          textB.stream]);
      var messages = [];
      underTest.listen((line) => messages.add(line)).onDone(expectAsync(() {
        print('Done');
        expect(messages, unorderedEquals(['A1', 'B1', 'A2', 'B2', 'A3', 'A4']));
      }));
      textA.add('A1');
      textA.add('A2');
      textA.add('A3');
      textA.add('A4');
      textB.add('B1');
      textB.add('B2');
      textA.close();
      textB.close();
    });
  });
}
