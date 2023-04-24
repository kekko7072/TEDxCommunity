import * as functions from "firebase-functions";
import {initializeApp, cert} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
import {Telegram} from "telegraf";
const telegram: Telegram = new Telegram(process.env.BOT_TOKEN as string);

export const params = {
  type: "service_account",
  projectId: process.env.G_SERVICE_PROJECT_ID,
  privateKeyId: process.env.G_SERVICE_ACCOUNT_PRIVATE_KEY_ID,
  private_key: process.env.G_SERVICE_ACCOUNT_PRIVATE_KEY,
  clientEmail: process.env.G_SERVICE_ACCOUNT_CLIENT_EMAIL,
  clientId: process.env.G_SERVICE_ACCOUNT_CLIENT_ID,
  authUri: "https://accounts.google.com/o/oauth2/auth",
  tokenUri: "https://oauth2.googleapis.com/token",
  authProviderX509CertUrl: "https://www.googleapis.com/oauth2/v1/certs",
  clientC509CertUrl: process.env.G_SERVICE_ACCOUNT_CLIENT_CERT_URL,
};

initializeApp({
  credential: cert(params),
});

export const SendTelegramMessageLicensecreated = functions
  .region("europe-west3")
  .firestore.document("licenses/{licenseId}")
  .onCreate(async (snap, context) => {
    try {
      const snapshot = await getFirestore()
        .collection("licenses")
        .count()
        .get();
      const chatId = process.env.CHAT_ID as string; // TO GET CHATID: https://telegram.me/get_id_bot

      await telegram.sendMessage(
        chatId,
        `
        🚀 New license activated in TEDxCommunity App:
            + LicenseId: ${context.params.licenseId}
            + Name: ${snap.data().licenseName}
            + Admin: ${snap.data().adminUid}

          Total licenses: ${snapshot.data().count}
        `
      );
    } catch (error) {
      console.error(`Error sending Telegram message: ${error}`);
    }
  });
