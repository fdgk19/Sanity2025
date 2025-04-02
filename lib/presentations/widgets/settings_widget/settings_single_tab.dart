import 'package:easy_localization/easy_localization.dart';
import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';

class SingleSettingTab extends StatelessWidget {
  final String text;
  final Function() onButtonPress;
  const SingleSettingTab({super.key, required this.text, required this.onButtonPress});

  @override
  Widget build(BuildContext context) {
    return  Padding(
            padding: const EdgeInsets.only(left: 0, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               Flexible(child: Text(text, style:const TextStyle(fontSize: 17, fontWeight: FontWeight.normal),)),
               IconButton(
                onPressed: onButtonPress,
                icon: const Icon(
                  Icons.arrow_right_alt_sharp, 
                  color: Colors.grey,)
               )
            ],),
          );
  }
}

class LanguageSettingTab extends StatefulWidget {
  final String text;
  final Function() needRebuild;
  const LanguageSettingTab({super.key, required this.text, required this.needRebuild});

  @override
  State<LanguageSettingTab> createState() => _LanguageSettingTabState();
}

class _LanguageSettingTabState extends State<LanguageSettingTab> {

  @override
  Widget build(BuildContext context) {
    return  Padding(
            padding: const EdgeInsets.only(left: 0, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               Flexible(child: Text(widget.text, style:const TextStyle(fontSize: 17, fontWeight: FontWeight.normal),)),
               DropdownButtonHideUnderline(
                 child: DropdownButton(
                  icon: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.transparent,
                        child: Flag.fromCode(
                          context.locale == const Locale('en', 'US') ? FlagsCode.GB : FlagsCode.IT,
                          height: 20,
                          width: 25,
                          fit: BoxFit.fill,
                        ),
                      ),
                  items: [
                    DropdownMenuItem(
                      alignment: Alignment.center,
                      value: const Locale('it', 'IT'),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.transparent,
                        child: Flag.fromCode(
                          FlagsCode.IT,
                          height: 20,
                          width: 25,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      alignment: Alignment.center,
                      value: const Locale('en', 'US'),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.transparent,
                        child: Flag.fromCode(
                          FlagsCode.GB,
                          height: 20,
                          width: 25,
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  ], 
                  onChanged: (value) async{
                    await context.setLocale(value ?? const Locale('it', 'IT'));
                    widget.needRebuild();
                  }
                               ),
               )
            ],),
          );
  }
}
