import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:homeaccountantapp/const.dart';


///
/// This is the about us page.
///


class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'About Us',
              style: GoogleFonts.lato(
                fontSize: baseFontSize.bigTitle,
                fontWeight: FontWeight.bold
              ),
            ),
          ]
        ),
        SizedBox(height: 32),
        Container(
          child: Column(
            children: [
              Text(
                'Home Accountant is a Free Open-Source Software (FOSS) built to manage bank accounts. It lets you create accounts, add transactions, organize them into categories and subcategories. It also provides various kinds of charts and graphs to help having a better understanding of your expenses. Our goal, as independent developers, was to create a free, simple, and user-friendly money managing application.',
                style: GoogleFonts.lato(
                  fontSize: baseFontSize.subtitle
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 12),
              Text(
                'Currently, Home Accountant does not use any Internet connection. As a result, it cannot share any of your data, especially the transactions you decided to save in this app. We care about your privacy.',
                style: GoogleFonts.lato(
                    fontSize: baseFontSize.subtitle
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 24),
              Text(
                'Home Accountant is licensed under the AGPL (Affero General Public License). The code is hosted at Codeberg; and also at Github and Gitlab, as mirrors. If you want to contribute, check out the links below!',
                style: GoogleFonts.lato(
                  fontSize: baseFontSize.subtitle
                ),
                textAlign: TextAlign.justify,
              )
            ],
          ),
        ),
        SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              child: SvgPicture.asset('assets/codeberg.svg', width: MediaQuery.of(context).size.width * 0.15),
              onTap: () async {
                String codeberg = 'https://codeberg.org/joristruong/homeaccountant-app';
                if (await canLaunch(codeberg)) {
                  await launch(codeberg);
                } else {
                  throw 'Could not launch $codeberg';
                }
              },
            ),
            InkWell(
              child: SvgPicture.asset('assets/github.svg', width: MediaQuery.of(context).size.width * 0.15),
                onTap: () async {
                String github = 'https://github.com/JorisTruong/homeaccountant-app';
                if (await canLaunch(github)) {
                  await launch(github);
                } else {
                  throw 'Could not launch $github';
                }
              }
            ),
            InkWell(
              child: SvgPicture.asset('assets/gitlab.svg', width: MediaQuery.of(context).size.width * 0.15),
              onTap: () async {
                String gitlab = 'https://gitlab.com/joris.truong/homeaccountant-app';
                if (await canLaunch(gitlab)) {
                  await launch(gitlab);
                } else {
                  throw 'Could not launch $gitlab';
                }
              }
            )
          ],
        )
      ]
    );
  }
}