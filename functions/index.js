const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// change firebaseId of sanity
exports.createCheckout = functions.https.onCall(async (data, context) => {
    const stripe = require('stripe')(functions.config().stripe.livekey);
  
    const session = await stripe.checkout.sessions.create({
      success_url: 'https://sanity-health.com/#/checkoutsuccess',
      cancel_url: 'https://sanity-health.com/#/checkouterror',
      line_items: 
      [
        { 
          price: data.priceId, 
          quantity: 1 
        },
      ],
      mode: 'subscription',
    });
  
    return { sessionId: session["id"], 
            stripeUrl: session["url"] };
});

exports.createCheckoutWithCoupon = functions.https.onCall(async (data, context) => {
  const stripe = require('stripe')(functions.config().stripe.livekey);

  const session = await stripe.checkout.sessions.create({
    success_url: 'https://sanity-health.com/#/checkoutsuccess',
    cancel_url: 'https://sanity-health.com/#/checkouterror',
    allow_promotion_codes: true,
    line_items: 
    [
      { 
        price: data.priceId, 
        quantity: 1 
      },
    ],
    mode: 'subscription',
  });

  return { sessionId: session["id"], 
          stripeUrl: session["url"] };
});

exports.stripeWebhookCreatedSubscription = functions.https.onRequest(async (req, res) => {
  const stripe = require("stripe")(functions.config().stripe.token);
  let event;

  try {
    const whSec = functions.config().stripe.payments_webhook_secret;

    event = stripe.webhooks.constructEvent(
      req.rawBody,
      req.headers["stripe-signature"],
      whSec,
    );
  } catch (err) {
    console.error("Webhook signature verification failed.");
    return res.sendStatus(400);
  }

  const dataObject = event.data.object;

  await admin.firestore().collection("subscriptions").doc().set({
    subscriptionId: dataObject.id,
    customer: dataObject.customer,
  });

  return res.sendStatus(200);
});

exports.stripeWebhookCancelSubscription = functions.https.onRequest(async (req, res) => {
  const stripe = require("stripe")(functions.config().stripe.token);
  let event;

  try {
    const whSec = functions.config().stripe.cancel_payments_webhook_secret;

    event = stripe.webhooks.constructEvent(
      req.rawBody,
      req.headers["stripe-signature"],
      whSec,
    );
  } catch (err) {
    console.error("Webhook signature verification failed.");
    return res.sendStatus(400);
  }

  const dataObject = event.data.object;
  console.log(dataObject.customer);
  
  let collectionRef = admin.firestore().collection("subscriptions");

  collectionRef.where("customer", "==", dataObject.customer)
    .get()
    .then(querySnapshot => {
      querySnapshot.forEach((doc) => {
        doc.ref.delete().then(() => {
          console.log("Document successfully deleted!");
        }).catch(function (error) {
          console.error("Error removing document: ", error);
        });
      });
    })
    .catch(function (error) {
      console.log("Error getting documents: ", error);
    });



  return res.sendStatus(200);
});

// exports.sendFollowNotificationTo = functions.https.onCall((data, context) => {
//   const myName = data.myName;
//   const hisToken = data.hisToken;

//   const payload = {
//     notification: {
//       title: "Sanity",
//       body: myName + " ha iniziato a seguirti", //Or you can set a server value here.
//     },
//   };
//   admin.messaging().sendToDevice(hisToken, payload)
//     .then(value => {
//       console.info("function executed succesfully");
//       return res.sendStatus(200);
//     })
//     .catch(error => {
//       console.info("error in execution");
//       console.log(error);
//       return { msg: "error in execution" };
//     });
// });

// exports.sendNewProgramNotificaion = functions.https.onCall((data, context) => {
//   const myName = data.myName;
//   const hisToken = data.hisToken;
//   const nameProgram = data.nameProgram;

//   const payload = {
//     notification: {
//       title: "Sanity",
//       body: myName + " ha creato un nuovo programma personalizzato per te: " + nameProgram, //Or you can set a server value here.
//     },
//   };
//   admin.messaging().sendToDevice(hisToken, payload)
//     .then(value => {
//       console.info("function executed succesfully");
//       return res.sendStatus(200);
//     })
//     .catch(error => {
//       console.info("error in execution");
//       console.log(error);
//       return { msg: "error in execution" };
//     });
// });

exports.getCustomerIdBySession = functions.https.onCall(async (data, context) => {
  // import the module
  const stripe = require('stripe')(functions.config().stripe.livekey)

  const sessionId = data.sessionId;

  const session = await stripe.checkout.sessions.retrieve(sessionId);

  return session['customer'];
});

exports.getSubscriptionStatus = functions.https.onCall(async (data, context) => {
  // import the module
  const stripe = require('stripe')(functions.config().stripe.livekey)

  const subscriptionId = data.subscriptionId;

  const subscription = await stripe.subscriptions.retrieve(
    subscriptionId
  );

  return subscription['status'];
//   return {cancel_at_period_end : subscription['cancel_at_period_end'],
//           created : subscription['created'],
//           current_period_end : subscription['current_period_end']};
});

exports.cancelSubscription = functions.https.onCall(async (data, context) => {
  // import the module
  const stripe = require('stripe')(functions.config().stripe.livekey)

  const subscriptionId = data.subscriptionId;

  const subscription = await stripe.subscriptions.del(
    subscriptionId
  );

  return {msg : 'ok'};
});

// exports.activateSubscriptionRenewal = functions.https.onCall(async (data,context) => {
//   // import the module
//   const stripe = require('stripe')(functions.config().stripe.livekey)

//   const subscriptionId = data.subscriptionId;

//   await stripe.subscriptions.update(
//     subscriptionId,
//     {cancel_at_period_end : 'false'}
//   );

//   return {msg : 'ok'};
// });

// exports.deactivateSubscriptionRenewal = functions.https.onCall(async (data,context) => {
//   // import the module
//   const stripe = require('stripe')(functions.config().stripe.livekey)

//   const subscriptionId = data.subscriptionId;

//   await stripe.subscriptions.update(
//     subscriptionId,
//     {cancel_at_period_end : 'true'}
//   );

//   return {msg : 'ok'};
// });