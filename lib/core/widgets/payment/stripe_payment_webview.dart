import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constants/route_constants.dart';

class StripePaymentWebView extends StatefulWidget {
  final String url;
  const StripePaymentWebView({super.key, required this.url});

  @override
  State<StripePaymentWebView> createState() => _StripePaymentWebViewState();
}

class _StripePaymentWebViewState extends State<StripePaymentWebView> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => isLoading = false);

            // --- SUCCESS CASE ---
            if (url.contains('success')) {
              // Show snackbar first
              Get.snackbar(
                "Payment Successful",
                "Your booking has been confirmed.",
                backgroundColor: const Color(0xFF1D3826),
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );

              // Navigate and clear the history so user can't "back" into payment
              Get.offAllNamed(RouteConstants.customerBookingSuccess,arguments: Get.arguments,);

              // Get.offAllNamed(
              //     RouteConstants.customerMainContainer,
              //     arguments: {'initialTab': 0}
              // );
            }

            // --- CANCEL/FAIL CASE ---
            else if (url.contains('cancel') || url.contains('fail')) {
              Get.back(); // Go back to Confirm Booking screen
              Get.snackbar(
                "Payment Cancelled",
                "You have cancelled the payment process.",
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("WebView Error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Secure Payment",style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF1D3826),
        // Important: If user closes manually, we treat it as a back action
        leading: IconButton(
          icon: const Icon(Icons.close,color: Colors.white,),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1D3826),
              ),
            ),
        ],
      ),
    );
  }
}