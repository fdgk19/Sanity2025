// ignore_for_file: avoid_print

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:sanity_web/commons/firestore/firestore_path.dart';
import 'package:sanity_web/commons/firestore/firestore_service.dart';
import 'package:sanity_web/data/models/checkout_model.dart';
import 'package:sanity_web/data/models/subscription_model.dart';
import 'package:sanity_web/data/services/interfaces/stripe_service.dart';

class StripeServiceImpl implements StripeService{
  final FirestoreService? firestoreService;

  StripeServiceImpl({@required this.firestoreService});
  
  @override
  Future<CheckoutModel?> createCheckout({required String priceId, required bool applyCoupon}) async {
    try {
      if(applyCoupon){
        HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createCheckoutWithCoupon');
        final cfResults = await callable.call(<String, dynamic>{
          'priceId': priceId,
        });
        var res = CheckoutModel.fromJson(cfResults.data);
        return res;
      }else{
        HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createCheckout');
        final cfResults = await callable.call(<String, dynamic>{
          'priceId': priceId,
        });
        var res = CheckoutModel.fromJson(cfResults.data);
        return res;
      }
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<SubscriptionModel?> getSubscription({required String sessionId}) async {
    String customerId;
    //get customer by sessionId
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getCustomerIdBySession');
      final resp = await callable.call(<String, dynamic>{
        'sessionId': sessionId,
      });        
      if(resp.data == null){
        return null;
      }
      customerId = resp.data as String;
    } on Exception catch (e) {
      print(e);
      return null;
    }

    //get subscription by customer
    var dbResult = await firestoreService!.collectionSnapshot(
        path: FirestorePath.subscriptions(),
        builder: (data, documentId) => SubscriptionModel.fromJson(data),
        queryBuilder: (query) {
          var tempQuery = query.where("customer", isEqualTo: customerId);
          return tempQuery;
        }
    );

    return dbResult.isEmpty ? null : dbResult.first;
  }
  
  @override
  Future<bool> cancelSubscription({required String subscriptionId}) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('cancelSubscription');
      final resp = await callable.call(<String, dynamic>{
        'subscriptionId': subscriptionId,
      });        
      return resp.data != null;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }   

  @override
  Future<bool> checkSubscriptionStatus({required String subscriptionId}) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getSubscriptionStatus');
      final resp = await callable.call(<String, dynamic>{
        'subscriptionId': subscriptionId,
      });
      return resp.data == 'active';
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }
  
}