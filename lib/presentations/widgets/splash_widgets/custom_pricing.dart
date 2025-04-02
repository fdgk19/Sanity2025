import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sanity_web/presentations/widgets/splash_widgets/custom_gradient_button.dart';

class CustomPricing extends StatefulWidget {
  final Function(String type) onSelectPlan;
  final IconData icon;
  final String planName;
  final String planDescription;
  final bool isPro;
  const CustomPricing(
      {Key? key,
      required this.onSelectPlan,
      required this.icon,
      required this.planName,
      required this.planDescription, required this.isPro})
      : super(key: key);

  @override
  State<CustomPricing> createState() => _CustomPricingState();
}

class _CustomPricingState extends State<CustomPricing>
    with SingleTickerProviderStateMixin {
  Color _shodowColor = Colors.grey.withOpacity(0.5);
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( 
      onTap: () {
        if(!widget.isPro){
          widget.onSelectPlan("");
        }
      },
      child: Row(
        children: [
          MouseRegion(
            cursor: widget.isPro ? MouseCursor.defer : SystemMouseCursors.click,
            onExit: (event) => {
              setState(() {
                _shodowColor = Colors.grey.withOpacity(0.5);
                isExpanded = false;
              })
            },
            onHover: (event) => {
              setState(() {
                _shodowColor = Colors.white.withOpacity(0.5);
                isExpanded = true;
              })
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              constraints: const BoxConstraints(
                  minHeight: 125, minWidth: 125, maxWidth: 125),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 49, 49, 49),
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(10),
                    topLeft: const Radius.circular(10),
                    bottomRight:
                        isExpanded ? Radius.zero : const Radius.circular(10),
                    topRight:
                        isExpanded ? Radius.zero : const Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _shodowColor,
                      spreadRadius: 1.5,
                      blurRadius: 2,
                      offset: const Offset(-2, 2),
                    ),
                    BoxShadow(
                      color: _shodowColor,
                      spreadRadius: 1.5,
                      blurRadius: 2,
                      offset: const Offset(-2, -2),
                    ),
                    BoxShadow(
                      color: _shodowColor,
                      offset: const Offset(0, -2),
                    ),
                    BoxShadow(
                      color: _shodowColor,
                      offset: const Offset(0, 2),
                    ),
                  ]),
              child: widget.isPro && isExpanded 
              ? Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0, left: 12, right: 12),
                      child: CustomGradientButton(
                        mainText: "18,90 €",
                        buttonPress: () => widget.onSelectPlan("m"),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0, left: 12, right: 12),
                      child: CustomGradientButton(
                        mainText: "189 €",
                        buttonPress: () => widget.onSelectPlan("y"),
                      )
                    )
                  ],
                ),
              )
              : Center(
                child: Column(
                  children: [
                    Icon(widget.icon,
                        color: const Color.fromARGB(255, 160, 160, 160)),
                    Text(
                      widget.planName,
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
          AnimatedOpacity(
              curve: Curves.linear,
              opacity: isExpanded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsets.only(left: 12, right: 12),
                constraints: const BoxConstraints(
                    minHeight: 125, minWidth: 250, maxWidth: 250),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _shodowColor,
                        spreadRadius: 1.5,
                        blurRadius: 2,
                        offset: const Offset(2, -2),
                      ),
                      BoxShadow(
                        color: _shodowColor,
                        spreadRadius: 1.5,
                        blurRadius: 2,
                        offset: const Offset(2, 2),
                      ),
                      BoxShadow(
                        color: _shodowColor,
                        offset: const Offset(0, -2),
                      ),
                      BoxShadow(
                        color: _shodowColor,
                        offset: const Offset(0, 2),
                      ),
                    ]),
                child: Center(
                  child: AutoSizeText(
                    widget.planDescription,
                    minFontSize: 11,
                    maxFontSize: 13,
                    textAlign: TextAlign.center,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}



class CustomPricingMobile extends StatefulWidget {
  final Function(String type) onSelectPlan;
  final IconData icon;
  final String planName;
  final String planDescription;
  final bool isPro;
  const CustomPricingMobile(
      {Key? key,
      required this.onSelectPlan,
      required this.icon,
      required this.planName,
      required this.planDescription, required this.isPro})
      : super(key: key);

  @override
  State<CustomPricingMobile> createState() => _CustomPricingMobileState();
}

class _CustomPricingMobileState extends State<CustomPricingMobile>
    with SingleTickerProviderStateMixin {
  Color _shodowColor = Colors.grey.withOpacity(0.5);
  bool isExpanded = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { 
         if(isExpanded){
           setState(() {
            _shodowColor = Colors.grey.withOpacity(0.5);
            isExpanded = false;
          });
        } else {
         setState(() {
            _shodowColor = Colors.white.withOpacity(0.5);
            isExpanded = true;
          });
        }
      } ,
      // onDoubleTap: () {
      //   if(!widget.isPro){
      //     widget.onSelectPlan("");
      //   }
      // },
      child: Row(
        children: [
          MouseRegion(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              constraints: const BoxConstraints(
                  minHeight: 120, minWidth: 120, maxWidth: 120),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 49, 49, 49),
                  borderRadius: const BorderRadius.only(
                    bottomLeft:  Radius.circular(10),
                    topLeft:  Radius.circular(10),
                    bottomRight:Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _shodowColor,
                      spreadRadius: 1.5,
                      blurRadius: 2,
                      offset: const Offset(-2, 2),
                    ),
                    BoxShadow(
                      color: _shodowColor,
                      spreadRadius: 1.5,
                      blurRadius: 2,
                      offset: const Offset(-2, -2),
                    ),
                    BoxShadow(
                      color: _shodowColor,
                      offset: const Offset(0, -2),
                    ),
                    BoxShadow(
                      color: _shodowColor,
                      offset: const Offset(0, 2),
                    ),
                  ]),
              child:
              //  widget.isPro && isExpanded 
              // ? Center(
              //   child: Column(
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.only(bottom: 6.0, left: 12, right: 12),
              //         child: CustomGradientButton(
              //           mainText: "18,90 €",
              //           buttonPress: () => widget.onSelectPlan("m"),
              //         )
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.only(top: 6.0, left: 12, right: 12),
              //         child: CustomGradientButton(
              //           mainText: "189 €",
              //           buttonPress: () => widget.onSelectPlan("y"),
              //         )
              //       )
              //     ],
              //   ),
              // )
              Center(
                child: Column(
                  children: [
                    Icon(widget.icon,
                        color: const Color.fromARGB(255, 160, 160, 160)),
                    Text(
                      widget.planName,
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
          AnimatedOpacity(
              curve: Curves.linear,
              opacity: isExpanded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsets.only(left: 12, right: 12),
                constraints: const BoxConstraints(
                    minHeight: 120, minWidth: 155, maxWidth: 155),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _shodowColor,
                        spreadRadius: 1.5,
                        blurRadius: 2,
                        offset: const Offset(2, -2),
                      ),
                      BoxShadow(
                        color: _shodowColor,
                        spreadRadius: 1.5,
                        blurRadius: 2,
                        offset: const Offset(2, 2),
                      ),
                      BoxShadow(
                        color: _shodowColor,
                        offset: const Offset(0, -2),
                      ),
                      BoxShadow(
                        color: _shodowColor,
                        offset: const Offset(0, 2),
                      ),
                    ]),
                child: Center(
                  child: AutoSizeText(
                    widget.planDescription,
                    minFontSize: 11,
                    maxFontSize: 13,
                    textAlign: TextAlign.center,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
