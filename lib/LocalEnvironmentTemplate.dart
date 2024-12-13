
import 'package:patta/Environment.dart';

class LocalEnvironment extends Environment {
  // (1) iOS can find a `.local` hostname:
  // LocalEnvironment() : super('http://solasa.local:3000');
  // (2) Android cannot find a hostname and requires your desktop's
  // local IP to find the Kosa server:
  // LocalEnvironment() : super('http://192.168.86.151:3000');

  // This variable is filled by the Makefile, which generates
  // 'Environment.dart' from 'EnvironmentTemplate.dart'.
  // Do not edit 'Environment.dart' because it will be overwritten.
  LocalEnvironment() : super('http://%MAKE_IP%:3000');
}
