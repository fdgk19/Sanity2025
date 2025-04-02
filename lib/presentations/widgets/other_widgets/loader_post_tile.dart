
import 'package:flutter/material.dart';
import 'package:sanity_web/data/models/user_model.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/loader_professional_tile.dart';

class LoadingPostTile extends StatefulWidget {
  const LoadingPostTile({Key? key}) : super(key: key);

  @override
  State<LoadingPostTile> createState() => _LoadingPostTileState();
}

class _LoadingPostTileState extends State<LoadingPostTile> {

  UserModel? userPost;

  @override
  void initState() {
   
   super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 0.1),
          borderRadius: const BorderRadius.all(Radius.circular(13))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
               //publisher info
            const Padding(
              padding:  EdgeInsets.only(left: 10,bottom: 10.0),
              child:  LoaderProfessionalTile(
                   
                  )
            ),
            //postinfo
            Container(
              width: 250,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12)),
              child: Stack(
                children: [
                  Container(
                    width: 250,
                    height: 200,
                    decoration: const BoxDecoration(
                       color: Color.fromARGB(255, 227, 227, 227),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                        //borderRadius: BorderRadius.circular(12)
                        ),
                  ),
                 
                  Column(
                    children: [
                     
                      const Divider(
                        height: 0,
                        thickness: 1.5,
                        color: Colors.white,
                      ),
                      const Spacer(),
                      Padding(
                              padding: const EdgeInsets.only(right: 8.0, bottom: 8),
                              child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: SizedBox(
                                    height: 20,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 2,
                                      itemBuilder: (context, index) {
                                        return  Container(
                                          width: 35,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                            color: Color.fromARGB(255, 227, 227, 227),
                                            borderRadius: BorderRadius.all(Radius.circular(4))
                                          ),
                                        );
                                      },
                                    ),
                                  )),
                            )
                    ],
                  ),
                ],
              ),
            ),
         
          ],
        ),
      ),
    );
  }
}
