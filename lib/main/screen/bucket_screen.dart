import 'package:auto_route/auto_route.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_parfumery/core/main/consants.dart';
import 'package:flutter_firebase_parfumery/core/main/globals.dart';
import 'package:flutter_firebase_parfumery/core/styles/widget/button_styles.dart';
import 'package:flutter_firebase_parfumery/main/widgets/cart/cart_decoration.dart';
import 'package:flutter_firebase_parfumery/widgets/loading_widget.dart';
import 'package:flutter_firebase_parfumery/widgets/show_loading_circle.dart';
import 'package:flutter_firebase_parfumery/widgets/show_snack_bar.dart';
import 'package:sizer/sizer.dart';

import '../bloc/bucket/bucket_bloc.dart';
import '../models/cart/cart.dart';
import '../widgets/cart/price_widget.dart';
@RoutePage()
class BucketScreen extends StatefulWidget {
  const BucketScreen({super.key});

  @override
  State<BucketScreen> createState() => _BucketScreenState();
}

class _BucketScreenState extends State<BucketScreen> {
  int sumall = 0;
  double shippingSum = 0;
  double subTotal = 0;
  sumAllCartitems() {
    for (Cart number in allCart) {
      sumall += number.price! * number.count!;
    }
    shippingSum = sumall / 80;
    subTotal = sumall + shippingSum;
    talker.log(sumall);
  }
  cleansum()  {
    sumall = 0;
    shippingSum = 0;
    subTotal = 0;
  }

  @override
  void initState() {
    super.initState();
    talker.log('inited');
    sumAllCartitems();
  }

  @override
  Widget build(BuildContext context) {
    final bloccommand = BlocProvider.of<BucketBloc>(context);
    int? sum;
    final textStyle = Theme.of(context).textTheme;
    final listIsempty = allCart.isEmpty;
    return BlocConsumer<BucketBloc, BucketState>(
      listener: (context, state) {
        if(state is BucketLoading){
          return showLoadingCircle(context);
        }
        if(state is BucketLoaded){
          cleansum();
          Navigator.of(context).pop();
          setState(() {sumAllCartitems();});
          ScaffoldMessenger.of(context)..clearMaterialBanners()..showSnackBar(materialBanner(good, 'Beautiful', ContentType.success));
        }
        if(state is BucketFailure){
          AutoRouter.of(context).popForced();
          ScaffoldMessenger.of(context)..clearMaterialBanners()..showSnackBar(materialBanner(oops, 'you forget information or server error', ContentType.failure));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  textAlign: TextAlign.left,
                  'My Cart',
                  style: textStylePicker(context).titleMedium,
                ),
                Text('${allCart.length} items',
                    style: textStylePicker(context).titleMedium)
              ],
            ),
            centerTitle: false,
          ),
          body: listIsempty
              ? const Center(
                  child: Text('Cart is empty'),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: allCart.length,
                        itemBuilder: (BuildContext context, int index) {
                          dynamic currentCart = allCart[index];
                            minusOne() async {
                            final countDefenition =
                            currentCart.count > 0 ? currentCart.count -1
                            : currentCart.count + 1;
                            currentCart =
                            currentCart.copyWith(
                            count:
                            countDefenition);
                            await mainRepository.changeCard(currentCart);
                            sumall = 0;
                            sumAllCartitems();
                            setState(() {});
                          }
                          return CachedNetworkImage(
                              imageUrl: currentCart.picUrls!.first,
                              placeholder: (context, url) {
                                return const loadingWidget();
                              },
                              errorWidget: (context, url, error) {
                                return Image.asset(errorIcon);
                              },
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      bottom: 1.5.h, right: 2.w, left: 2.w),
                                  decoration: cartDecoration,
                                  height: 25.h,
                                  width: 95.w,
                                  child: Stack(children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only(left: 3.w),
                                            height: 20.h,
                                            width: 35.w,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover)),
                                                ))),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 4.h,
                                            ),
                                            Text(
                                              currentCart.title!,
                                              style: textStylePicker(context)
                                                  .titleMedium,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                ),
                                                Text(
                                                  currentCart.rating.toString(),
                                                  style:
                                                      textStylePicker(context)
                                                          .titleSmall,
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Text(
                                                  '${currentCart.price} \$',
                                                  style:
                                                      textStylePicker(context)
                                                          .titleSmall,
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 3.h,
                                            ),
                                            Container(
                                              height: 7.h,
                                              width: 50.w,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 228, 228, 228),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {

                                                        minusOne();
                                                      },
                                                      icon: const Icon(
                                                        CupertinoIcons
                                                            .minus_circle_fill,
                                                        color: Colors.white,
                                                      )),
                                                  Container(
                                                      width: 20.w,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      child: Text(
                                                        currentCart.count
                                                            .toString(),
                                                        style: textStylePicker(
                                                                context)
                                                            .titleSmall,
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                  IconButton(
                                                      onPressed: () {
                                                        plusOne() async {
                                                          currentCart =
                                                              currentCart.copyWith(
                                                                  count: currentCart.count + 1);
                                                          await mainRepository.changeCard(currentCart);
                                                          sumall = 0;
                                                          sumAllCartitems();
                                                          setState(() {});
                                                        }

                                                        plusOne();
                                                      },
                                                      icon: const Icon(
                                                        Icons.add_circle,
                                                        color: Colors.white,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Positioned(
                                        top: 0.5.h,
                                        left: 83.w,
                                        child: IconButton(
                                            onPressed: () async {
                                              bloccommand.add(BucketEvent(ifDelete: true, cart: currentCart));
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.xmark,
                                            )))
                                  ]),
                                );
                              });
                        },
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(left: 3.w, right: 3.w,top: 1.h),
                      decoration: cartDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          price_widget(
                            textStyle: textStyle,
                            price: sumall.toString(),
                            title: 'Cart items price:',
                          ),
                          price_widget(
                              textStyle: textStyle,
                              title: 'Shipping price',
                              price: shippingSum.toString()),
                          price_widget(
                              textStyle: textStyle,
                              title: 'Subtotal',
                              price: subTotal.toString()),
                          Container(
                            margin: EdgeInsets.only(
                                left: 5.w, right: 5.w, top: 2.h, bottom: 2.h),
                            decoration: auth_button_container,
                            child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Checkout',
                                  style: textStyle.displayMedium,
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    )
                  ],
                ),
        );
      },
    );
  }
}
