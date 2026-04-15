import { http } from '@kit.NetworkKit';

const AGENT_ENDPOINT = 'http://127.0.0.1:7854/ingest/ec88a7c1-483b-436b-84bf-1a937b95923b';
const SESSION_ID = '1540a6';

/** Debug NDJSON ingest (session 1540a6). Do not log secrets/PII. */
export function agentLog(
  location: string,
  message: string,
  data: Record<string, string | number | boolean | undefined>,
  hypothesisId: string,
  runId: string = 'pre-fix'
): void {
  // #region agent log
  const payload = JSON.stringify({
    sessionId: SESSION_ID,
    location,
    message,
    data,
    timestamp: Date.now(),
    hypothesisId,
    runId
  });
  const req = http.createHttp();
  req.request(AGENT_ENDPOINT, {
    method: http.RequestMethod.POST,
    header: {
      'Content-Type': 'application/json',
      'X-Debug-Session-Id': SESSION_ID
    },
    extraData: payload,
    connectTimeout: 3000,
    readTimeout: 3000
  }).then(() => {
    req.destroy();
  }).catch(() => {
    req.destroy();
  });
  // #endregion
}
