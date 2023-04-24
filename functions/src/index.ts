import * as functions from "firebase-functions";
import { Telegram } from "telegraf";
const telegram: Telegram = new Telegram(process.env.BOT_TOKEN as string);
const chatId = process.env.CHAT_ID as string;

export const SendTelegramMessageLicensecreated = functions
  .region("europe-west3")
  .firestore.document("licenses/{licenseId}")
  .onCreate(async (snap, context) => {
    try {
      // Get the newly created user document's data
      await telegram.sendMessage(
        chatId,
        `🚀 New user in TEDxCommunity App\nLicenseId: ${
          context.params.licenseId
        }\nName: ${snap.data().licenseName}\nAdmin: ${snap.data().adminUid}`
      );
    } catch (error) {
      console.error(`Error sending Telegram message: ${error}`);
    }
  });
