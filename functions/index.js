'use strict';

const {onRequest} = require('firebase-functions/v2/https');
const logger = require('firebase-functions/logger');
const {defineSecret} = require('firebase-functions/params');
const {GoogleAuth} = require('google-auth-library');

const notifyApiKey = defineSecret('NOTIFY_API_KEY');
const notifyBackendBaseUrl = defineSecret('NOTIFY_BACKEND_BASE_URL');
const messagingScope = 'https://www.googleapis.com/auth/firebase.messaging';
const projectId =
  process.env.GCLOUD_PROJECT || process.env.GCP_PROJECT || 'ciac-school';
const allowedNotificationTypes = new Set(['homework', 'activity']);

exports.sendNotification = onRequest(
  {
    region: 'asia-southeast1',
    secrets: [notifyApiKey, notifyBackendBaseUrl],
  },
  async (req, res) => {
    res.set('Access-Control-Allow-Origin', '*');
    res.set(
      'Access-Control-Allow-Headers',
      'Authorization, Content-Type, X-API-Key',
    );
    res.set('Access-Control-Allow-Methods', 'POST, OPTIONS');

    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    if (req.method !== 'POST') {
      res.status(405).json({error: 'Method not allowed. Use POST.'});
      return;
    }

    const providedApiKey = req.get('x-api-key') || '';
    const expectedApiKey = notifyApiKey.value();
    if (!expectedApiKey || providedApiKey !== expectedApiKey) {
      res.status(401).json({error: 'Unauthorized'});
      return;
    }

    const authorizationHeader = req.get('authorization') || '';
    const accessToken = extractBearerToken(authorizationHeader);
    if (!accessToken) {
      res.status(401).json({
        error: 'Missing Authorization bearer token.',
      });
      return;
    }

    const validationError = validateRequestBody(req.body);
    if (validationError) {
      res.status(400).json({error: validationError});
      return;
    }

    const {
      token,
      tokens,
      topic,
      title,
      body,
      data,
      imageUrl,
    } = req.body;

    try {
      const teacherProfile = await authorizeTeacherSend({
        accessToken,
        baseUrl: notifyBackendBaseUrl.value(),
      });
      const googleAccessToken = await getAccessToken();
      const endpoint =
        `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`;

      const targets = buildTargets({token, tokens, topic});
      const responses = [];

      for (const target of targets) {
        const message = buildMessage({
          target,
          title,
          body,
          data,
          imageUrl,
        });

        const response = await fetch(endpoint, {
          method: 'POST',
          headers: {
            Authorization: `Bearer ${googleAccessToken}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({message}),
        });

        const responseBody = await response.json();
        if (!response.ok) {
          logger.error('FCM send failed', responseBody);
          res.status(response.status).json({
            error: 'FCM request failed',
            details: responseBody,
          });
          return;
        }

        responses.push({
          target: target.token || target.topic,
          name: responseBody.name,
        });
      }

      res.status(200).json({
        success: true,
        senderRole: teacherProfile.role,
        count: responses.length,
        responses,
      });
    } catch (error) {
      logger.error('Unexpected sendNotification error', error);
      res.status(500).json({
        error: 'Unable to send notification',
        details: error instanceof Error ? error.message : String(error),
      });
    }
  },
);

function validateRequestBody(body) {
  if (!body || typeof body !== 'object') {
    return 'Request body must be a JSON object.';
  }

  const hasToken = typeof body.token === 'string' && body.token.trim() !== '';
  const hasTokens =
    Array.isArray(body.tokens) &&
    body.tokens.some((item) => typeof item === 'string' && item.trim() !== '');
  const hasTopic = typeof body.topic === 'string' && body.topic.trim() !== '';

  if (!hasToken && !hasTokens && !hasTopic) {
    return 'Provide token, tokens, or topic.';
  }

  const title = typeof body.title === 'string' ? body.title.trim() : '';
  const messageBody = typeof body.body === 'string' ? body.body.trim() : '';
  if (!title && !messageBody) {
    return 'Provide title or body.';
  }

  const type = resolveNotificationType(body);
  if (!type) {
    return 'Provide data.type or data.category as homework or activity.';
  }

  if (body.data !== undefined) {
    if (typeof body.data !== 'object' || Array.isArray(body.data)) {
      return 'data must be an object of string values.';
    }

    for (const [key, value] of Object.entries(body.data)) {
      if (typeof value !== 'string') {
        return `data.${key} must be a string.`;
      }
    }
  }

  return null;
}

function buildTargets({token, tokens, topic}) {
  if (typeof topic === 'string' && topic.trim() !== '') {
    return [{topic: topic.trim()}];
  }

  if (Array.isArray(tokens)) {
    return tokens
      .filter((item) => typeof item === 'string')
      .map((item) => item.trim())
      .filter(Boolean)
      .map((item) => ({token: item}));
  }

  return [{token: token.trim()}];
}

function buildMessage({target, title, body, data, imageUrl}) {
  const message = {
    notification: {},
    data: normalizeData(data),
    android: {
      priority: 'HIGH',
      notification: {
        sound: 'homework_notification',
      },
    },
    apns: {
      payload: {
        aps: {
          sound: 'homework_notification.wav',
        },
      },
    },
  };

  if (target.token) {
    message.token = target.token;
  }
  if (target.topic) {
    message.topic = target.topic;
  }
  if (title) {
    message.notification.title = title;
  }
  if (body) {
    message.notification.body = body;
  }
  if (imageUrl) {
    message.notification.image = imageUrl;
    message.android.notification.image = imageUrl;
    message.apns.fcm_options = {image: imageUrl};
  }
  if (Object.keys(message.notification).length === 0) {
    delete message.notification;
  }
  if (!message.data) {
    delete message.data;
  }

  return message;
}

function normalizeData(data) {
  if (!data || typeof data !== 'object' || Array.isArray(data)) {
    return undefined;
  }

  const normalized = {};
  for (const [key, value] of Object.entries(data)) {
    normalized[key] = value;
  }
  return Object.keys(normalized).length > 0 ? normalized : undefined;
}

function extractBearerToken(headerValue) {
  if (typeof headerValue !== 'string') {
    return '';
  }

  const match = headerValue.match(/^Bearer\s+(.+)$/i);
  return match ? match[1].trim() : '';
}

function resolveNotificationType(body) {
  if (!body || typeof body !== 'object') {
    return '';
  }

  const candidates = [
    body.type,
    body.category,
    body.data && body.data.type,
    body.data && body.data.category,
  ];

  for (const candidate of candidates) {
    const normalized =
      typeof candidate === 'string' ? candidate.trim().toLowerCase() : '';
    if (allowedNotificationTypes.has(normalized)) {
      return normalized;
    }
  }

  return '';
}

async function authorizeTeacherSend({accessToken, baseUrl}) {
  const normalizedBaseUrl = normalizeBaseUrl(baseUrl);
  if (!normalizedBaseUrl) {
    throw new Error('NOTIFY_BACKEND_BASE_URL secret is not configured.');
  }

  const response = await fetch(`${normalizedBaseUrl}/api/v1/your-profile`, {
    method: 'GET',
    headers: {
      Authorization: `Bearer ${accessToken}`,
      Accept: 'application/json',
    },
  });

  const responseBody = await response.json().catch(() => null);
  if (!response.ok) {
    logger.error('Teacher authorization profile lookup failed', responseBody);
    const error = new Error('Unable to verify sender role.');
    error.statusCode = response.status;
    throw error;
  }

  const profile = extractProfile(responseBody);
  const role = extractRole(profile);
  if (role !== 'teacher') {
    const error = new Error('Only teacher accounts can send notifications.');
    error.statusCode = 403;
    throw error;
  }

  return {role, profile};
}

function normalizeBaseUrl(baseUrl) {
  const normalized = typeof baseUrl === 'string' ? baseUrl.trim() : '';
  if (!normalized) {
    return '';
  }
  return normalized.endsWith('/') ? normalized.slice(0, -1) : normalized;
}

function extractProfile(responseBody) {
  if (!responseBody || typeof responseBody !== 'object') {
    return {};
  }

  const data =
    responseBody.data && typeof responseBody.data === 'object' ?
      responseBody.data :
      responseBody;

  if (data.user && typeof data.user === 'object') {
    return data.user;
  }

  return data;
}

function extractRole(profile) {
  const candidates = [
    profile.role,
    profile.type,
    profile.user_role,
    profile.userType,
  ];

  for (const candidate of candidates) {
    const normalized =
      typeof candidate === 'string' ? candidate.trim().toLowerCase() : '';
    if (normalized) {
      return normalized;
    }
  }

  return '';
}

async function getAccessToken() {
  const auth = new GoogleAuth({scopes: [messagingScope]});
  const client = await auth.getClient();
  const accessToken = await client.getAccessToken();

  if (!accessToken || !accessToken.token) {
    throw new Error('Failed to acquire Google access token.');
  }

  return accessToken.token;
}
