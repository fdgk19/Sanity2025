import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanity_web/presentations/state_management/auth_provider.dart';
import 'package:sanity_web/presentations/state_management/new_post_provider.dart';
import 'package:sanity_web/presentations/state_management/stripe_provider.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/choose_content.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/choose_content_draft.dart';
import 'package:easy_localization/easy_localization.dart';

class CreatePostChoose extends StatefulWidget {
  const CreatePostChoose({Key? key}) : super(key: key);

  @override
  State<CreatePostChoose> createState() => _CreatePostChooseState();
}

class _CreatePostChooseState extends State<CreatePostChoose> {
  bool forceDraft = false;
  bool checkInProgress = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Wrap(
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            spacing: 100,
            runSpacing: 25,
            children: [
          ChooseContent(
            image: "lib/resources/images/empty_model.png",
            icon: Icons.edit,
            buttonText: tr("new_model"),
            description: tr("description_new_model"),
            forceDraft: forceDraft,
            checkInProgress: checkInProgress,
            onChoose: () async{
              var user = context.read<AuthProvider>().currentUser;
              if(user.counterFreePost < 3){
                AutoRouter.of(context).pop(true);
              }else if(user.isPremium){
                setState(() {
                  checkInProgress = true;
                });
                var check = await context.read<StripeProvider>().checkSubscriptionStatus();
                setState(() {
                  checkInProgress = false;
                });
                if(check && mounted){
                  AutoRouter.of(context).pop(true);
                }else{
                  setState(() {
                    forceDraft = true;
                  });  
                }
              }else{
                setState(() {
                  forceDraft = true;
                });
              }
            },
          ),
          ChooseContentDraft(
            image: "lib/resources/images/draft_model.png",
            icon: Icons.download,
            buttonText: tr("upload_draft"),
            description:
                tr("description_upload_draft"),
            onChoose: (postId) async{
              await context.read<NewPostProvider>().initDraftPost(postId: postId);
              if(mounted){
                AutoRouter.of(context).pop(false);
              }
            },
          ),
        ]));
  }
}
