# FCM HTTP v1 sender

This directory contains a Firebase Cloud Function named `sendNotification`.

It sends push notifications through the Firebase Cloud Messaging HTTP v1 API by
using the Cloud Function service account to mint a Google access token at
runtime.

## 1. Install dependencies

```bash
cd functions
npm install
```

## 2. Set the required secrets

```bash
firebase functions:secrets:set NOTIFY_API_KEY
firebase functions:secrets:set NOTIFY_BACKEND_BASE_URL
```

Use:

- `NOTIFY_API_KEY`: shared key sent as `X-API-Key`
- `NOTIFY_BACKEND_BASE_URL`: your backend base URL, for example
  `https://ciac.school.softcreative.live`

## 3. Deploy

```bash
firebase deploy --only functions
```

## 4. Request body

Send a `POST` request to the deployed `sendNotification` URL.

Required headers:

```http
Authorization: Bearer USER_ACCESS_TOKEN
X-API-Key: YOUR_SHARED_KEY
Content-Type: application/json
```

```json
{
  "token": "DEVICE_FCM_TOKEN",
  "title": "New Homework",
  "body": "Math exercises were added.",
  "data": {
    "type": "homework",
    "category": "homework"
  }
}
```

You can also use:

- `tokens`: an array of device tokens
- `topic`: a topic name instead of token or tokens
- `imageUrl`: optional notification image URL

Only authenticated users whose backend profile role resolves to `teacher`
can send notifications, and only `homework` or `activity` notification types
are accepted.

## Example curl

```bash
curl -X POST "YOUR_FUNCTION_URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer USER_ACCESS_TOKEN" \
  -H "X-API-Key: YOUR_SHARED_KEY" \
  -d "{\"token\":\"DEVICE_FCM_TOKEN\",\"title\":\"New Homework\",\"body\":\"Math exercises were added.\",\"data\":{\"type\":\"homework\",\"category\":\"homework\"}}"
```
