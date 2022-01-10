import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_huawei_obs/flutter_huawei_obs.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await FlutterHuaweiObs.platformVersion ?? 'Unknown platform version';
      await FlutterHuaweiObs.initConfig(
          endPoint: "https://obs.cn-east-3.myhuaweicloud.com",
          accessKey: "BTGRU6KQ5HTUIXQOM6BD",
          secretKey: "REnZi2fcKKV0PjcpTvVtUysQ6ZtryNhER8k4EML6",
          securityToken: "gQljbi1lYXN0LTOHLt0aor5IQWoUWb6N9T6WqdT_RK0C3tzBlyD5mrwRi9BPMhqra8ucP-DmGEdYYKyx2QrTd27v02-uwikTInMEB3rCo3xLxUJJxPb2hcbDG5GdfEZr6QnPoVdIFKXYe9Z8Hu8j0N19V8sSK-EuoWiCnLUR1cqz99m7V2_XIeZlevwVdRq6FBbi9j6l8Rr64Oi_kGhVnkQJe8nsE44q8QHbExEK6_R4u2fymABLbLnKXPSF1UynlEifXpUD3RSovB6nrK47Yd9wnLbtA2iY8L2WLriqI_VOqcFWE_fz-5u1r-yINb2YGPmZN4VzoHSzwFgUjFhuBmiO_xU8hQ3uwLMNMZ6JWov_FpIhAvlhJSx8vdsWjKMl5p4Ii9tNmw8LpZAk-RWPCQDJ5IY2PX7pHju33NSMvl54SvnyG69Ke6gmVdSfR4zvKdmCZuRQoLkdg3mkjFd4jAifP8VQaGxxuyNjj4O5fa1LFv0fxQLYTVvfrV9NkwaPkiRHTAbIPLhRFTtKAgAX8rpKmkSpWOrZxOqIs6mzRSwJEi0MPnokv-F6GVFlGTGXtI_Zwt4GYTxG21FW-RMjWiy4LhiUj7YmcZCz3V-3dbnARm44Td0cc0npHcor8S0F0SMTkyHrko_nhzouFasRjYmSNFNExTstg7HHMPCEBchaosgjs0TFZmzxv7Pgj1VGhWW1gPrSahns3Oqk3o0gKx0UbrYr_Jpn3ARYzQlBwr0HxFCdY8VwygsZArTlomiyRdk_P_-6w7nRpcOQaaTsfxsH6cHkPOmcbFFm7vJW_9NOi7mvqYb8B33a8wM=");
      // await FlutterHuaweiObs.putObject(bucketname: "isong", objectname: "test/test", objectContent: "test");
      // await FlutterHuaweiObs.putFile(bucketname: "isong", objectname: "test/test", filePath: "/sdcard/DCIM/Camera/IMG_20180926_191810.jpg");
    } on Exception {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: GestureDetector(
              child: Text('Running on: $_platformVersion\n'),
            onTap: () async {
              final _picker = ImagePicker();
              XFile? image = await _picker.pickImage(source: ImageSource.gallery);
              String? result = await FlutterHuaweiObs.putFile(bucketname: "isong", objectname: "test/test_img.jpg", filePath: image?.path ?? "");
              print("------------------->$result");

            },
          ),
        ),
      ),
    );
  }
}
