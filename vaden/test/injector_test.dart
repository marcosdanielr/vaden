import 'package:test/test.dart';
import 'package:vaden/vaden.dart';

void main() {
  test('injector test', () {
    final injector = AutoInjector();

    injector.add(ServiceTestImpl.new);

    print(injector.tryGet<ServiceTest>());
  });
}

abstract class ServiceTest {}

class ServiceTestImpl implements ServiceTest {}
