import * as functions from "firebase-functions";
import {Telegram} from "telegraf";
const telegram: Telegram = new Telegram(process.env.BOT_TOKEN as string);
const chatId = "@kekko7072";

export const SendTelegramMessageLicensecreated = functions
  .region("europe-west3")
  .firestore.document("license/{licenseId}")
  .onCreate(async (snap, context) => {
    await telegram.sendMessage(
      chatId,
      `🚀 New user in TEDxCommunity App\nLicenseId: ${
        context.params.licenseId
      }\nName: ${snap.data().licenseName}\nAdmin: ${snap.data().adminUid}`
    );
  });
