import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qlthuvien/models/Product.dart';
import 'package:qlthuvien/pages/productDetail.dart';

class FavoriteItemWidget extends StatelessWidget {
  final Product product;

  const FavoriteItemWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 130,
                      child: Image.network(
                        product.imageUrl ??
                            'https://firebasestorage.googleapis.com/v0/b/qlthuvien-ff034.appspot.com/o/hinhanh%2Flogo.png?alt=media&token=8c567db1-9c7b-423d-8e68-d154bcbc7219',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/default_product.png');
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "${product.unitPrice} VND",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0,70,10,0),
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProductDetailPage(product: product)),
                              );
                            },
                            child: Text('Xem chi tiết >>',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16
                                ))
                        )
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
