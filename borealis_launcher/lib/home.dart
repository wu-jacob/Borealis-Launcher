import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final BouncingScrollPhysics _bouncingScrollPhysics =
      const BouncingScrollPhysics();
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formattedTime = DateFormat('HH:mm').format(now);
    var formattedDate = DateFormat('EEE, d MMM').format(now);

    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/testwallpaper.png'),
              fit: BoxFit.fill,
            )),
            child: PageView(
              controller: controller,
              children: [
                const Center(
                  child: Text(
                    "Settings Page",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 150.0,
                        ),
                        child: Text(
                          formattedTime,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                        ),
                        child: Text(
                          formattedDate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                FutureBuilder(
                  future: DeviceApps.getInstalledApplications(
                    includeSystemApps: true,
                    onlyAppsWithLaunchIntent: true,
                    includeAppIcons: true,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      List<Application> allApps = snapshot.data!;

                      return GridView.count(
                          crossAxisCount: 3,
                          padding: const EdgeInsets.only(
                            top: 60.0,
                          ),
                          physics: _bouncingScrollPhysics,
                          children: List.generate(allApps.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                DeviceApps.openApp(allApps[index].packageName);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Image.memory(
                                      (allApps[index] as ApplicationWithIcon)
                                          .icon,
                                      width: 32,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      allApps[index].appName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }));
                    }

                    return Container(
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                )
              ],
            )));
  }
}
