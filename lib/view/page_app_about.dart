// Copyright 2023 Fries_I23
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../common/consts.dart';
import '../component/widget.dart';
import '../model/about_info.dart';
import 'common/_dialog.dart';
import 'for_app_about/_widget.dart';

Future<void> naviToAppAboutPage({required BuildContext context}) async {
  return Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (context) => const PageAppAbout(),
    ),
  );
}

class PageAppAbout extends StatelessWidget {
  const PageAppAbout({super.key});

  Future<AboutInfo> loadData() async {
    String rawJson = await rootBundle.loadString(aboutInfoFilePath);
    Map<String, Object?> data = jsonDecode(rawJson);
    return AboutInfo.fromJson(data);
  }

  @override
  Widget build(BuildContext context) => FutureProvider<AboutInfo>(
        create: (_) async => loadData(),
        initialData: const AboutInfo(),
        child: const AppAboutView(),
      );
}

class AppAboutView extends StatefulWidget {
  const AppAboutView({super.key});

  @override
  State<StatefulWidget> createState() => _AppAboutView();
}

class _AppAboutView extends State<AppAboutView> {
  void _onDonateTilePressed() async {
    final aboutInfo = context.read<AboutInfo>();
    showDonateDialog(
      context,
      donateBuyMeACoffeeToken: aboutInfo.donateBuyMeACoffeeToken,
      donatePaypalToken: aboutInfo.donatePaypalToken,
      btcAddress: aboutInfo.donateCryptoBTCAddr,
      ethAddress: aboutInfo.donateCryptoETHAddr,
      bnbAddress: aboutInfo.donateCryptoBNBAddr,
      avaxAddress: aboutInfo.donateCryptoAVAXAddr,
      ftmAddress: aboutInfo.donateCryptoFTMAddr,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const PageBackButton(reason: PageBackReason.back),
        title: L10nBuilder(
          builder: (context, l10n) => l10n != null
              ? Text(l10n.appAbout_appbarTile_titleText)
              : const Text("About"),
        ),
      ),
      body: ListView(
        children: [
          const AppAboutVersionTile(
            isMonoLogo: true,
            logoPath: "assets/logo/icon-momo.svg",
            changeLogPath: "CHANGELOG.md",
          ),
          const AppAboutSourceCodeTile(),
          const AppAboutIssueTrackerTile(),
          const AppAboutContactEmailTile(),
          const AppAboutLicenseTile(),
          const AppAboutThirdPartyLicenseTile(),
          AppAboutDonateTile(onPressed: _onDonateTilePressed),
        ],
      ),
    );
  }
}
