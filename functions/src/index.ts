import * as functions from "firebase-functions";
import {Telegram} from "telegraf";
const telegram: Telegram = new Telegram(process.env.BOT_TOKEN as string);
const chatId = process.env.CHAT_ID as string; // TO GET CHATID: https://telegram.me/get_id_bot

export const SendTelegramMessageLicensecreated = functions
  .region("europe-west3")
  .firestore.document("licenses/{licenseId}")
  .onCreate(async (snap, context) => {
    try {
      await telegram.sendMessage(
        chatId,
        `🚀 New license activated in TEDxCommunity App
        \n\n
        LicenseId: ${context.params.licenseId}\n
        Name: ${snap.data().licenseName}\n
        Admin: ${snap.data().adminUid}\n
        \n\n
        `
      );
    } catch (error) {
      console.error(`Error sending Telegram message: ${error}`);
    }
  });
