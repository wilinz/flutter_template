import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:url_launcher/url_launcher_string.dart';

import '../../../route.dart';
import 'profile_vm.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(),
      child: _ProfilePage(),
    );
  }
}

class _ProfilePage extends StatefulWidget {
  const _ProfilePage({Key? key}) : super(key: key);

  @override
  State<_ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<_ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<ProfileViewModel>(builder: (context, viewModel, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("个人主页"),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Card(
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoute.loginPage, arguments: true);
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage("images/logo.png"),
                              width: 48,
                              height: 48,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(("first name") +
                                    (" second name")),
                                SizedBox(height: 4),
                                Text("info"),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: Text.rich(
                          TextSpan(children: [
                            TextSpan(
                                text:
                                    "一个 Flutter App 模板，可以让你快速开发 App\n"),
                            TextSpan(
                                text: "https://github.com/wilinz/flutter_template",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launcher.launchUrl(
                                        Uri.parse(
                                            "https://github.com/wilinz/flutter_template"),
                                        mode: LaunchMode.externalApplication);
                                  })
                          ]),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<ProfileViewModel>(context, listen: false);
  }

  @override
  bool get wantKeepAlive => true;
}
