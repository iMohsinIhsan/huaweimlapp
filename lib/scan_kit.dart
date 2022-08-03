import 'package:flutter/material.dart';

import 'package:huawei_scan/HmsScan.dart';
import 'package:huawei_scan/HmsScanLibrary.dart';
import 'package:huawei_scan/hmsCustomizedView/CustomizedViewRequest.dart';
import 'package:huawei_scan/hmsCustomizedView/HmsCustomizedView.dart';
import 'package:huawei_scan/hmsMultiProcessor/HmsMultiProcessor.dart';
import 'package:huawei_scan/hmsMultiProcessor/MultiCameraRequest.dart';
import 'package:huawei_scan/hmsMultiProcessor/ScanTextOptions.dart';
import 'package:huawei_scan/hmsScanPermissions/HmsScanPermissions.dart';
import 'package:huawei_scan/hmsScanUtils/BuildBitmapRequest.dart';
import 'package:huawei_scan/hmsScanUtils/DecodeRequest.dart';
import 'package:huawei_scan/hmsScanUtils/DefaultViewRequest.dart';
import 'package:huawei_scan/hmsScanUtils/HmsScanUtils.dart';
import 'package:huawei_scan/model/AddressInfo.dart';
import 'package:huawei_scan/model/BorderRect.dart';
import 'package:huawei_scan/model/ContactDetail.dart';
import 'package:huawei_scan/model/CornerPoint.dart';
import 'package:huawei_scan/model/DriverInfo.dart';
import 'package:huawei_scan/model/EmailContent.dart';
import 'package:huawei_scan/model/EventInfo.dart';
import 'package:huawei_scan/model/EventTime.dart';
import 'package:huawei_scan/model/LinkUrl.dart';
import 'package:huawei_scan/model/LocationCoordinate.dart';
import 'package:huawei_scan/model/PeopleName.dart';
import 'package:huawei_scan/model/ScanResponse.dart';
import 'package:huawei_scan/model/ScanResponseList.dart';
import 'package:huawei_scan/model/SmsContent.dart';
import 'package:huawei_scan/model/TelPhoneNumber.dart';
import 'package:huawei_scan/model/WiFiConnectionInfo.dart';
import 'package:huawei_scan/utils/HmsScanErrors.dart';
import 'package:huawei_scan/utils/HmsScanForm.dart';
import 'package:huawei_scan/utils/HmsScanTypes.dart';

class ScanKit extends StatefulWidget {
  const ScanKit({Key? key}) : super(key: key);

  @override
  State<ScanKit> createState() => _ScanKitState();
}

class _ScanKitState extends State<ScanKit> {
  ScanResponse? scanResponse;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan Kit')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                await HmsScanPermissions.requestCameraAndStoragePermissions();
                DefaultViewRequest request =
                    DefaultViewRequest(scanType: HmsScanTypes.AllScanType);
                //Calling defaultView API with the request object.
                await HmsScanUtils.startDefaultView(request);
                //Obtain the result.
                ScanResponse response =
                    await HmsScanUtils.startDefaultView(request);
                setState(() {
                  scanResponse = response;
                });
//Print the result.
                debugPrint('QR Code Result');
                debugPrint('QR Code Result');
                debugPrint(response.showResult);
                debugPrint('QR Code Result');
                debugPrint('QR Code Result');
                debugPrint('QR Code Result');
                debugPrint('QR Code Result');
              },
              child: Text('Scan'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SelectableText(
                      scanResponse != null
                          ? scanResponse!.showResult!
                          : "Please scan QR Code",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
