import 'package:flutter/material.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/generated/flutter_gen/assets.gen.dart';
import 'package:go_to/utilities/helpers/ui_helper.dart';
import 'package:go_to/views/pages/main_page/blocs/main_cubit.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key, required this.parentContext,
    required this.parentCubit, required this.parentState,
  }) : super(key: key);

  final BuildContext parentContext;
  final MainCubit parentCubit;
  final MainState parentState;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(height: DimenConstants.getProportionalScreenHeight(context, 10),),

          //close button
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: DimenConstants.getProportionalScreenWidth(context, 7),),
            child: GestureDetector(
              onTap: () => closeDrawer(context),
              child: Icon(
                Icons.close_rounded, color: ColorConstants.baseGrey,
                size: DimenConstants.getProportionalScreenWidth(context, 30,),
              ),
            ),
          ),
          SizedBox(height: DimenConstants.getProportionalScreenHeight(context, 15),),

          //main body
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   //user's name
                  Padding(
                    padding: EdgeInsets.only(left: DimenConstants.getProportionalScreenWidth(context, 8),),
                    child: Text(
                      "ABC", style: TextStyle(
                        fontSize: DimenConstants.getProportionalScreenWidth(context, 17),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  UIHelper.buildDivider(context, margin: 10),

                  //home choice
                  _buildClickableItem(
                    context, index: 0, iconData: Icons.home_rounded, label: StringConstants.home,
                    onTap: () {
                      closeDrawer(context);
                      parentCubit.changePageIndex(index: 0);
                    },
                  ),
                  UIHelper.buildDivider(context),

                  //profile choice
                  _buildClickableItem(
                    context, index: 1, iconData: Icons.account_circle_outlined, label: StringConstants.profile,
                      onTap: () {
                        closeDrawer(context);
                        parentCubit.changePageIndex(index: 1);
                      },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: DimenConstants.getProportionalScreenHeight(context, 15),),

          //sign out choice
          _buildClickableItem(
            context, iconData: Icons.logout, label: StringConstants.signOut,
            onTap: () => parentCubit.logout(parentContext),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableItem(BuildContext context, {
    int index = -1, SvgGenImage? svgGen, IconData iconData = Icons.error,
    String label = "", void Function()? onTap,
  }) {
    final isChosen = parentState.currentIndex == index;
    final itemColor = index == -1 ? ColorConstants.baseRed
        : (isChosen ? ColorConstants.orange : ColorConstants.baseBlack);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          top: DimenConstants.getProportionalScreenHeight(context, 10),
          bottom: DimenConstants.getProportionalScreenHeight(context, 10),
        ),
        child: Row(
          children: [
            SizedBox(width: DimenConstants.getProportionalScreenWidth(context, 8,),),

            //icon
            svgGen != null ? svgGen.svg(color: itemColor) : Icon(iconData, color: itemColor,),
            SizedBox(width: DimenConstants.getProportionalScreenWidth(context, 4),),

            //label
            Expanded(
              child: Text(
                label, style: TextStyle(
                  fontSize: DimenConstants.getProportionalScreenWidth(context, 17),
                  fontWeight: isChosen ? FontWeight.w600 : FontWeight.w400,
                  color: itemColor,
                ),
              ),
            ),

            SizedBox(width: DimenConstants.getProportionalScreenWidth(context, 8,),),
          ],
        ),
      ),
    );
  }

  void closeDrawer(BuildContext context) {
    Navigator.of(context).pop();
  }
}
