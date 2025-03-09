// /**
//  * Import function triggers from their respective submodules:
//  *
//  * import {onCall} from "firebase-functions/v2/https";
//  * import {onDocumentWritten} from "firebase-functions/v2/firestore";
//  *
//  * See a full list of supported triggers at https://firebase.google.com/docs/functions
//  */
//
// import {onRequest} from "firebase-functions/v2/https";
// import * as logger from "firebase-functions/logger";
//
// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
//
// // export const helloWorld = onRequest((request, response) => {
// //   logger.info("Hello logs!", {structuredData: true});
// //   response.send("Hello from Firebase!");
// // });

import {onDocumentCreated} from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();
const fcm = admin.messaging();

// Function to send notifications when a new post is added
export const sendPostNotification = onDocumentCreated("posts/{postId}"
  , async (event) => {
    const postData = event.data?.data();
    if (!postData) return;

    const message = postData.message;
    const username = postData.username || "Someone";

    try {
    // Get all users' FCM tokens except the sender
      const usersSnapshot = await db.collection("users").get();
      const tokens: string[] = [];

      usersSnapshot.forEach((doc) => {
        const userData = doc.data();
        if (userData.fcmToken && userData.username !== username) {
          tokens.push(userData.fcmToken);
        }
      });

      if (tokens.length === 0) return;

      // Construct the push notification payload
      const payload = {
        notification: {
          title: "New Post Added!",
          body: `${username}: ${message}`,
        },
        tokens: tokens,
      };

      // Send notifications
      await fcm.sendMulticast(payload);
      console.log("Notification sent for new post:", message);
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  }
);

