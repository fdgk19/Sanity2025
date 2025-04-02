import 'package:sanity_web/data/models/checkout_model.dart';
import 'package:sanity_web/data/models/subscription_model.dart';

abstract class StripeService {
  Future<CheckoutModel?> createCheckout({required String priceId, required bool applyCoupon});
  Future<bool> cancelSubscription({required String subscriptionId});
  Future<SubscriptionModel?> getSubscription({required String sessionId});
  Future<bool> checkSubscriptionStatus({required String subscriptionId});
}