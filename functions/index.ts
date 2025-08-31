// functions/src/index.ts
import { onRequest } from "firebase-functions/v2/https";
import { setGlobalOptions } from "firebase-functions/v2";
import { defineSecret, defineString } from "firebase-functions/params";
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import cors from "cors";

import sgMail from "@sendgrid/mail";
import * as crypto from "crypto";
// 🔴 getFirestore() 이전, 최상단에서 설정
const usingEmulator =
  process.env.FUNCTIONS_EMULATOR === "true" ||
  !!process.env.FIRESTORE_EMULATOR_HOST;

if (usingEmulator && !process.env.FIRESTORE_EMULATOR_HOST) {
  process.env.FIRESTORE_EMULATOR_HOST = "127.0.0.1:8080";
}
console.log("FIRESTORE_EMULATOR_HOST =", process.env.FIRESTORE_EMULATOR_HOST);
console.log("FUNCTIONS_EMULATOR =", process.env.FUNCTIONS_EMULATOR);

initializeApp();
setGlobalOptions({
  region: "asia-northeast1",
  memory: "256MiB",
  timeoutSeconds: 60,
});

const db = getFirestore();

const SENDGRID_API_KEY = defineSecret("SENDGRID_API_KEY");
const FROM_EMAIL = defineString("FROM_EMAIL", {
  default: "verypool.service@gmail.com",
});

const CODE_TTL_MS = 10 * 60 * 1000;
const sha256 = (s: string) =>
  crypto.createHash("sha256").update(s).digest("hex");
const genCode = () => Math.floor(100000 + Math.random() * 900000).toString();
const _cors = cors({ origin: true });

export const sendEmailCode = onRequest(
  { secrets: [SENDGRID_API_KEY] }, // ← secrets 지정
  (req, res) => {
    _cors(req, res, async () => {
      if (req.method !== "POST") {
        res.status(405).send("Method Not Allowed");
        return;
      }

      const { email } = (req.body || {}) as { email?: string };
      if (!email) {
        res.status(400).json({ ok: false, error: "email required" });
        return;
      }

      // secrets/value 접근은 핸들러 내부에서
      sgMail.setApiKey(SENDGRID_API_KEY.value());
      const from = FROM_EMAIL.value();

      const code = genCode();

      const msg: sgMail.MailDataRequired = {
        to: email,
        from, // string OK
        subject: "[인증 코드] Verypool 회원가입 인증 코드",
        text: `인증 코드: ${code}`,
        html: `<strong>인증 코드: ${code}</strong>`,
      };

      try {
        await sgMail.send(msg);
        console.log("Email sent");
      } catch (e) {
        console.error("SendGrid error", e);
        res.status(500).json({ ok: false, error: "send_failed" });
        return;
      }

      res.json({ ok: true, mockCode: code });
    });
  }
);

export const verifyEmailCode = onRequest(
  { secrets: [SENDGRID_API_KEY] },
  (req, res) => {
    _cors(req, res, async () => {
      if (req.method !== "POST") {
        res.status(405).send("Method Not Allowed");
        return;
      }

      // 1초 대기
      await new Promise((resolve) => setTimeout(resolve, 1000));
      res.json({ ok: true });
    });
  }
);
