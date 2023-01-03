import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_flutter/widgets/icons.dart';
import 'package:project_flutter/widgets/svg_asset.dart';

class DiscoverCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Color? gradientStartColor;
  final Color? gradientEndColor;
  final double? height;
  final double? width;
  final Widget? vectorBottom;
  final Widget? vectorTop;
  final Function? onTap;
  final String? tag;
  final Widget? icons;
  const DiscoverCard(
      {Key? key,
      this.title,
      this.subtitle,
      this.gradientStartColor,
      this.gradientEndColor,
      this.height,
      this.width,
      this.vectorBottom,
      this.vectorTop,
      this.onTap,
      this.tag,
      this.icons,
      required SvgAsset icon,
      required List<SvgAsset> children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap!(),
        borderRadius: BorderRadius.circular(26),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              colors: [
                gradientStartColor ?? Color(0xff441DFC),
                gradientEndColor ?? Color(0xff4E81EB),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Container(
            height: 190,
            width: 320,
            //------------
            //decoration: BoxDecoration(
            //  image: DecorationImage(
            //    fit: BoxFit.cover,
            //    image: AssetImage('assets/icons/background1.png'),
            //  ),
            //),
            child: Stack(
              children: [
                vectorBottom ??
                    ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: SvgAsset(
                          height: 190,
                          width: 320,
                          assetName: AssetName.vectorBottom),
                    ),
                vectorTop ??
                    ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: SvgAsset(
                          height: 190,
                          width: 320,
                          assetName: AssetName.vectorTop),
                    ),
                Padding(
                  padding: EdgeInsets.only(left: 24, top: 24, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: tag ?? '',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                title!,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          subtitle != null
                              ? Text(
                                  subtitle!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white),
                                )
                              : Container(),
                        ],
                      ),
                      Row(
                        children: [
                          //icons ??
                          //    SvgAsset(
                          //      assetName: AssetName.headphone,
                          //      height: 24,
                          //      width: 24,
                          //    ),
                          //    SizedBox(width: 24),
                          //    SvgAsset(
                          //      assetName: AssetName.sensor,
                          //      height: 24,
                          //      width: 24,
                          //    ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
