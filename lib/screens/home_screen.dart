import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:streaksmate/models/streaks_model.dart';
import 'package:streaksmate/screens/add_streaks_screen.dart';
import 'package:streaksmate/screens/drawer_screen.dart';
import 'package:streaksmate/services/db_service.dart';
import 'package:streaksmate/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final DbProvider _dbProvider = DbProvider();
  List<Streak> _streakList = [];
  void updateStreakList() async {
    List<Streak> newList = await _dbProvider.getStreakList();
    setState(() {
      _streakList = newList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            headerSection(),
            const TotalStreaksWidget(),
            AllStreaks(
              allstreaks: _streakList,
            ),
          ],
        ),
      ),
    );
  }

  Widget headerSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  key.currentState!.openDrawer();
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.redColor.withOpacity(0.1),
                  child: const Icon(
                    Icons.menu,
                    color: AppColors.redColor,
                  ),
                ),
              ),
              const Text(
                "Streaks Add",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                onTap: () async {
                  if (await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddStreaksScreen(),
                        ),
                      ) !=
                      0) {
                    setState(() {
                      updateStreakList();
                    });
                  }
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.redColor.withOpacity(0.1),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.redColor,
                  ),
                ),
              ),
            ],
          ),
          const Gap(10.0),
        ],
      ),
    );
  }
}

class TotalStreaksWidget extends StatelessWidget {
  const TotalStreaksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreakWidget(
              color: AppColors.redColor,
              title: "Total Streaks",
              total: "10",
            ),
            StreakWidget(
              color: AppColors.redColor,
              title: "Added Streaks",
              total: "23",
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.all(15.0),
          width: double.infinity,
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            children: [
              Text(
                "100",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 40.0,
                      color: AppColors.secondaryColor,
                    ),
              ),
              const Text(
                "Remaining Streaks",
                style: TextStyle(
                  fontSize: 20.0,
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class StreakWidget extends StatelessWidget {
  final Color color;
  final String total;
  final String title;
  const StreakWidget({
    super.key,
    required this.color,
    required this.total,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          children: [
            Text(
              total,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontSize: 40.0,
                    color: AppColors.secondaryColor,
                  ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                color: AppColors.secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllStreaks extends StatelessWidget {
  final List<Streak> allstreaks;
  const AllStreaks({super.key, required this.allstreaks});

  @override
  Widget build(BuildContext context) {
    return allstreaks.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(30.0),
              Image.asset(
                "assets/no_data.png",
                height: 150.0,
                width: 150.0,
              ),
              const Text(
                "No Streaks Found",
                style: TextStyle(
                  fontSize: 16.0,
                  color: AppColors.redColor,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15.0),
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppColors.redColor,
                ),
                child: const Center(
                  child: Text(
                    "Add new streaks",
                    style: TextStyle(color: AppColors.secondaryColor),
                  ),
                ),
              ),
            ],
          )
        : Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    "All Streaks",
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: allstreaks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 15.0),
                              width: double.infinity,
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: AppColors.redColor.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(
                                  10.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                    height: 80.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: AppColors.primaryColor,
                                    ),
                                    child: const Icon(
                                      Icons.book,
                                      color: AppColors.secondaryColor,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Snapchat",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: AppColors.secondaryColor,
                                          ),
                                        ),
                                        Gap(10.0),
                                        SizedBox(
                                          width: 200.0,
                                          child: LinearProgressIndicator(
                                            value: 60 / 100,
                                            valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
                                          ),
                                        ),
                                        Gap(10.0),
                                        Text(
                                          "Yes, you can do it.",
                                          style: TextStyle(
                                            color: AppColors.secondaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(20.0),
                                  const Text(
                                    "20",
                                    style: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
