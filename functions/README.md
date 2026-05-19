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

## 2. Set the shared API key secret

```bash
firebase functions:secrets:set NOTIFY_API_KEY
```

Use the same value in the `X-API-Key` request header when calling the function.

## 3. Deploy

```bash
firebase deploy --only functions
```

## 4. Request body

Send a `POST` request to the deployed `sendNotification` URL.

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

## Example curl

```bash
curl -X POST "YOUR_FUNCTION_URL" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: YOUR_SHARED_KEY" \
  -d "{\"token\":\"DEVICE_FCM_TOKEN\",\"title\":\"New Homework\",\"body\":\"Math exercises were added.\",\"data\":{\"type\":\"homework\",\"category\":\"homework\"}}"
```
