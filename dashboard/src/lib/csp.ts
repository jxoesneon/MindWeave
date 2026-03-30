/**
 * Content Security Policy Headers
 * Add these to your web server configuration (nginx, apache, or Vercel)
 * 
 * For Vercel (vercel.json):
 * {
 *   "headers": [
 *     {
 *       "source": "/(.*)",
 *       "headers": [
 *         {
 *           "key": "Content-Security-Policy",
 *           "value": "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self'; connect-src 'self' https://*.supabase.co; frame-ancestors 'none'; base-uri 'self'; form-action 'self';"
 *         },
 *         {
 *           "key": "X-Content-Type-Options",
 *           "value": "nosniff"
 *         },
 *         {
 *           "key": "X-Frame-Options",
 *           "value": "DENY"
 *         },
 *         {
 *           "key": "X-XSS-Protection",
 *           "value": "1; mode=block"
 *         },
 *         {
 *           "key": "Referrer-Policy",
 *           "value": "strict-origin-when-cross-origin"
 *         }
 *       ]
 *     }
 *   ]
 * }
 * 
 * For nginx:
 * add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self'; connect-src 'self' https://*.supabase.co; frame-ancestors 'none'; base-uri 'self'; form-action 'self';" always;
 * add_header X-Content-Type-Options nosniff always;
 * add_header X-Frame-Options DENY always;
 * add_header X-XSS-Protection "1; mode=block" always;
 * add_header Referrer-Policy strict-origin-when-cross-origin always;
 */

export const CSP_POLICY = {
  'default-src': ["'self'"],
  'script-src': ["'self'", "'unsafe-inline'", "'unsafe-eval'"],
  'style-src': ["'self'", "'unsafe-inline'"],
  'img-src': ["'self'", "data:", "https:"],
  'font-src': ["'self'"],
  'connect-src': ["'self'", "https://*.supabase.co"],
  'frame-ancestors': ["'none'"],
  'base-uri': ["'self'"],
  'form-action': ["'self'"],
}

export function buildCSPHeader(): string {
  return Object.entries(CSP_POLICY)
    .map(([key, values]) => `${key} ${values.join(' ')}`)
    .join('; ')
}
