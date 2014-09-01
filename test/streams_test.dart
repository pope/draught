import 'dart:async';
import 'package:draught/streams.dart' as streams;
import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';

main() {
  useVMConfiguration();
  unittestConfiguration..timeout = new Duration(seconds: 1);

  group('streams', () {
    test('unify', () {
      var textA = new StreamController<String>();
      var textB = new StreamController<String>();
      Stream<String> underTest = streams.unify([textA.stream, textB.stream]);
      var messages = [];
      underTest.listen((line) => messages.add(line)).onDone(expectAsync(() {
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

    test('rateLimit', () {
      var text = new StreamController<String>();
      Stream<Iterable<String>> underTest = streams.rateLimit(text.stream,
          new Duration(milliseconds: 1));
      var messages = [];
      underTest.listen((line) => messages.add(line)).onDone(expectAsync(() {
        expect(messages, equals([['A1'], ['A2', 'A3']]));
      }));
      text.add('A1');
      text.add('A2');
      text.add('A3');
      text.close();
    });
  });
}
