import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:streaksmate/models/streaks_model.dart';
import 'package:streaksmate/services/db_service.dart';
import 'package:streaksmate/utils/colors.dart';
import 'package:streaksmate/utils/constants.dart';
import 'package:streaksmate/widgets/custom_text_field.dart';
import 'package:streaksmate/widgets/streaks_container.dart';
import 'package:streaksmate/widgets/streaks_dialog.dart';
import 'package:streaksmate/widgets/streaks_menu.dart';

class AddStreaksScreen extends StatefulWidget {
  const AddStreaksScreen({super.key});

  @override
  State<AddStreaksScreen> createState() => _AddStreaksScreenState();
}

class _AddStreaksScreenState extends State<AddStreaksScreen> {
  final DbProvider _dbProvider = DbProvider();
  final _textFieldController = TextEditingController();
  int _currentIconIndex = 0;
  bool _showCursor = true;
  bool _check = false;
  Color _checkColor = AppColors.primaryColor;
  final String _titleText = "";
  final key = GlobalKey<FormState>();
  @override
  void initState() {
    _textFieldController.text = '60';
    super.initState();
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  void _chooseIcon() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StreakDialog(
          onIconChange: (icon) {
            setState(() {
              print(icon);
              _currentIconIndex = icon;
            });
          },
        );
      },
    );
  }

  Widget _getChip(String text) {
    return StreakContainer(
      onTap: () {
        setState(() {
          _textFieldController.text = text;
          _showCursor = false;
        });
      },
      color: AppColors.primaryColor,
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.secondaryColor,
        ),
      ),
    );
  }

  Future<int> _insertStreak(Streak streak) async {
    return await _dbProvider.insertStreak(streak);
  }

  Widget _getCounters(IconData icon, bool add) {
    return StreakContainer(
      color: AppColors.redColor.withOpacity(0.1),
      onTap: () {
        _showCursor = false;
        int curr = 0;
        if (add) {
          curr = int.parse(_textFieldController.text) + 1;
        } else {
          curr = int.parse(_textFieldController.text) - 1;
          if (curr < 0) curr = 0;
        }
        _textFieldController.text = curr.toString();
        setState(() {});
      },
      child: Icon(
        icon,
        color: AppColors.redColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: Form(
            key: key,
            child: Column(
              children: <Widget>[
                headerSection(),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 20.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Text(
                    "Enter your streak name and select total streaks count",
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(
                      16.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        CustomTextField(
                          controller: _textFieldController,
                          labelText: "Add your title",
                          validator: (value) {
                            if (value == null || value == "") {
                              return "please enter title";
                            } else {
                              return null;
                            }
                          },
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  _getCounters(Icons.remove, false),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: TextField(
                                        onTap: () {
                                          setState(() {
                                            _showCursor = true;
                                          });
                                        },
                                        showCursor: _showCursor,
                                        keyboardType: TextInputType.number,
                                        controller: _textFieldController,
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  _getCounters(Icons.add, true),
                                ],
                              ),
                              const Gap(20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _getChip('100'),
                                  _getChip('200'),
                                  _getChip('300'),
                                  _getChip('500'),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 16.0,
                                  top: 16.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      16.0,
                                    ),
                                    color: AppColors.primaryColor.withOpacity(0.2),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: <Widget>[
                                        StreakMenu(
                                          onTap: () {
                                            _chooseIcon();
                                          },
                                          icon: Icon(
                                            AppConst.iconList[_currentIconIndex],
                                            color: AppColors.primaryColor,
                                          ),
                                          text: 'Choose Icon',
                                        ),
                                        StreakMenu(
                                          onTap: () {
                                            setState(() {
                                              if (!_check) {
                                                _check = true;
                                                _checkColor = AppColors.primaryColor;
                                              } else {
                                                _check = false;
                                                _checkColor = AppColors.secondaryColor;
                                              }
                                            });
                                          },
                                          icon: Icon(
                                            Icons.fiber_manual_record,
                                            color: _checkColor,
                                          ),
                                          text: 'Reset (on miss)',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        if (key.currentState!.validate()) {
                          Streak streak = Streak(
                            _titleText,
                            int.parse(_textFieldController.text),
                          );
                          await _insertStreak(streak).then((result) {
                            Navigator.pop(context, result);
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: AppColors.primaryColor,
                        ),
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headerSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.redColor.withOpacity(0.1),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.redColor,
                ),
              ),
            ),
            const Text(
              "Add Streaks",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            InkWell(
              onTap: () {},
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
    );
  }
}
