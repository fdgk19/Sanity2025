import 'package:flutter/cupertino.dart';
import 'package:sanity_web/data/models/checkout_model.dart';
import 'package:sanity_web/data/services/interfaces/stripe_service.dart';
import 'package:sanity_web/data/services/interfaces/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StripeProvider with ChangeNotifier {
  final StripeService? stripeService;
  final UserService? userService;
  final SharedPreferences? sharedPreferences;

  StripeProvider(
      {@required this.userService,
      @required this.stripeService,
      @required this.sharedPreferences});

  bool loading = false;

  CheckoutModel? _checkout;

  CheckoutModel? get checkout => _checkout;

  _startOperation() {
    loading = true;
    notifyListeners();
  }

  _endOperation() {
    loading = false;
    notifyListeners();
  }

  Future<void> getCheckoutSession(String priceId, bool applyCoupon) async {
    _startOperation();
    var doctorId = sharedPreferences!.getString("userId");
    if (doctorId != null) {
      _checkout = await stripeService!.createCheckout(priceId: priceId, applyCoupon: applyCoupon);
      if(checkout != null){
        await userService!.updateSessionIdAndIsPremium(userId: doctorId, sessionId: checkout!.sessionId,  isPremium: false);
      }
    }
    _endOperation();
  }

  Future<void> cancelSubscription() async {
    _startOperation();
    if (checkout == null || checkout!.subscription == null) {
      return;
    }
    var res = await stripeService!.cancelSubscription(
        subscriptionId: checkout!.subscription!.subscriptionId!);
    if (res) {
      _checkout = null;
      var doctorId = sharedPreferences!.getString("userId");
      if (doctorId != null) {
        await userService!.updateSessionIdAndIsPremium(userId: doctorId, sessionId: null, isPremium: false);
      }
    }
    _endOperation();
  }

  Future<bool> checkSubscriptionStatus() async {
    //_startOperation();
    final user = await userService!.getByUserId(userId: sharedPreferences!.getString('userId') ?? "");
    if (user.sessionId == null || user.sessionId!.isEmpty) {
      //_endOperation();
      return false;
    }
    final subscription =
        await stripeService!.getSubscription(sessionId: user.sessionId ?? "");
    if (subscription == null) {
      //_endOperation();
      return false;
    }
    bool subscriptionStatus = await stripeService!.checkSubscriptionStatus(
        subscriptionId: subscription.subscriptionId ?? "");
    
    if(subscriptionStatus != user.isPremium){
      await userService!.updateSessionIdAndIsPremium(userId: user.uid, sessionId: user.sessionId, isPremium: subscriptionStatus);
    }
    if(subscriptionStatus){
      _checkout = CheckoutModel(
        sessionId: user.sessionId,
        subscription: subscription
      );
    }
    //_endOperation();
    return subscriptionStatus;
  }
}