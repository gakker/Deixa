import 'package:flutter/material.dart';

import '../data/repository/remote/crypto/crypto_repo_impl.dart';

class CryptoTesting extends StatelessWidget {
  CryptoTesting({Key? key}) : super(key: key);
  CryptoRepoImpl cryptoRepoImpl = CryptoRepoImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: TextButton(
          onPressed: () {
            // cryptoRepoImpl.getAllDatas();
            // cryptoRepoImpl.getCryptoCarousel();
            // cryptoRepoImpl.getCryptoMovers();
            // cryptoRepoImpl.getCryptoNews();
          },
          child: Text("Crypto Featues Testing"),
        )),
      ),
    );
  }
}
