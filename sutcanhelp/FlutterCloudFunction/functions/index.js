const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);


var newData;

exports.myTrigger = functions.firestore.document('LearnBookSOS/{id}').onCreate(async (snapshot, context) => {
    //

    if (snapshot.empty) {
        console.log('No Devices');
        return;
    }
    var tokens = [];

    newData = snapshot.data();

    const deviceIdTokens = await admin
        .firestore()
        .collection("UserTokens")
        .get();

    for (var token of deviceIdTokens.docs) {
        tokens.push(token.data().device_token);
    }


    var payload = {
        notification: {
            title: 'ติววิชา: ' + newData.Subject,
            body: 'สถานที่: '+newData.Location +', '+newData.Time + ', ' + newData.Date,
            sound: 'default',

        },
        data: { click_action: 'FLUTTER_NOTIFICATION_CLICK', message: newData.Time + ', ' + newData.Date },
    };

    try {
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log('Notification sent successfully');
    } catch (err) {
        console.log('Error sending Application');
    }
});
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
