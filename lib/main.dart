// @dart=3.0
import 'package:patta/Environment.dart';
import 'package:patta/LocalEnvironment.dart';
import 'package:patta/main_common.dart';
import 'package:patta/main_config.dart';

// import 'LocalEnvironmentTemplate.dart';

Future<void> main() async {
  if(EnvironmentConfig.BUILD_ENV == "production"){
      await mainCommon(ProductionEnvironment());
  } else if(EnvironmentConfig.BUILD_ENV == "sandbox"){
      await mainCommon(SandboxEnvironment());
  }
  else {
      await mainCommon(LocalEnvironment());
  }
}
