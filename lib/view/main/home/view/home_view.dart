import 'package:flutter/material.dart';
import 'package:paycode/core/components/cards/product_box_card.dart';
import 'package:paycode/core/components/textfield/search_text_field.dart';
import 'package:paycode/core/constants/colors.dart';
import 'package:paycode/core/constants/size.dart';
import 'package:paycode/core/funcs/toast_message.dart';
import 'package:paycode/core/init/theme/theme_notifier.dart';
import 'package:paycode/view/detail/view/detail_view.dart';
import 'package:paycode/view/main/home/model/product_model.dart';
import 'package:paycode/view/main/home/viewmodel/product_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:paycode/core/extensions/size_extension.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  TextEditingController _searchTextController = TextEditingController();

  late AnimationController _controller;
  late Animation<Color?> _color;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _color = ColorTween(
            begin: ConstantColors.productAddColor,
            end: ConstantColors.bottomBarGreenIconColor)
        .animate(_controller);

    _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).customTheme;
    final _productViewModel = Provider.of<ProductViewModel>(context);
    return ListView(
      children: [
        Padding(
          padding: context.maximumPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hoş geldin",
                    style: theme!.themeData!.textTheme.headline2,
                  ),
                  Text(
                    "Mert Can Kıyak",
                    style: theme.themeData!.textTheme.headline6,
                  ),
                ],
              ),
              Image.network(
                "https://i.hizliresim.com/4bkrv2k.png",
                scale: 10,
              ),
            ],
          ),
        ),
        Padding(
          padding: context.mediumSymetricPadding,
          child: SearchTextFormField(
            hintText: "Markette Arayın",
            icon: Icon(Icons.search),
            textEditingController: _searchTextController,
          ),
        ),
        FutureBuilder(
            future: _productViewModel.getFeaturedProducts(),
            builder: (BuildContext context,
                AsyncSnapshot<List<ProductModel>> snapshots) {
              if (snapshots.hasData) {
                return Container(
                  width: context.getWidth * 0.50,
                  height: context.getHeight * 0.44,
                  child: ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshots.data!.length,
                      itemBuilder: ((BuildContext context, int index) {
                        return ProductCardBox(
                          key: ValueKey(index),
                          productModel: snapshots.data![index],
                        );
                      })),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        Padding(
          padding: context.spesificPadding(0, SizeConstants.mediumSize,
              SizeConstants.maximumSize, SizeConstants.maximumSize),
          child: Text(
            "Yeni Eklenenler",
            style: theme.themeData!.textTheme.headline6,
          ),
        ),
        FutureBuilder(
            future: _productViewModel.getNewProducts(),
            builder: (BuildContext context,
                AsyncSnapshot<List<ProductModel>> snapshots) {
              if (snapshots.hasData) {
                return ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshots.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: context.mediumPadding,
                        child: Container(
                          width: context.getWidth,
                          height: context.getHeight * 0.1,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(
                                    0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: context.getWidth * 0.2,
                                      height: context.getWidth * 0.15,
                                      decoration: BoxDecoration(
                                          color: ConstantColors.softGrey
                                              .withOpacity(0.1),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Padding(
                                        padding: context.minimumPadding,
                                        child: Image.network(
                                            snapshots.data![index].urunFoto!),
                                      ),
                                    ),
                                    SizedBox(
                                      width: SizeConstants.minimumSize,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshots.data![index].urunAdi!,
                                            style: theme
                                                .themeData!.textTheme.headline6,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: SizeConstants.minimumSize,
                                          ),
                                          Text(snapshots.data![index].urunTur!,
                                              style: theme.themeData!.textTheme
                                                  .headline2),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "${snapshots.data![index].urunFiyat!} TL",
                                style: theme.themeData!.textTheme.bodyText2,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return Text("Veri gelmedi");
              }
            }),
      ],
    );
  }
}
