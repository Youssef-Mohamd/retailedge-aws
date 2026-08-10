from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
from datetime import datetime, timezone

HOST = "0.0.0.0"
PORT = 8080


HTML = """<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>RetailEdge | AWS Application</title>
  <style>
    :root {
      color-scheme: dark;
      --bg: #08111f;
      --panel: rgba(15, 27, 48, .86);
      --panel-border: rgba(148, 163, 184, .16);
      --text: #f8fafc;
      --muted: #94a3b8;
      --accent: #38bdf8;
      --accent-2: #6366f1;
      --success: #22c55e;
    }

    * { box-sizing: border-box; }

    body {
      margin: 0;
      min-height: 100vh;
      font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      color: var(--text);
      background:
        radial-gradient(circle at 15% 20%, rgba(56, 189, 248, .18), transparent 30%),
        radial-gradient(circle at 85% 15%, rgba(99, 102, 241, .2), transparent 28%),
        linear-gradient(135deg, #08111f 0%, #0b1730 55%, #111827 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 32px 18px;
    }

    .container { width: min(1050px, 100%); }

    .hero {
      position: relative;
      overflow: hidden;
      padding: 48px;
      border: 1px solid var(--panel-border);
      border-radius: 28px;
      background: linear-gradient(145deg, rgba(15, 27, 48, .94), rgba(15, 23, 42, .78));
      box-shadow: 0 30px 80px rgba(0, 0, 0, .35);
      backdrop-filter: blur(16px);
    }

    .hero::after {
      content: "";
      position: absolute;
      width: 280px;
      height: 280px;
      right: -120px;
      bottom: -150px;
      border-radius: 50%;
      background: rgba(56, 189, 248, .12);
      filter: blur(10px);
    }

    .badge {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 7px 12px;
      border-radius: 999px;
      color: #bae6fd;
      background: rgba(14, 165, 233, .12);
      border: 1px solid rgba(56, 189, 248, .2);
      font-size: 13px;
      font-weight: 700;
      letter-spacing: .04em;
      text-transform: uppercase;
    }

    .dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: var(--success);
      box-shadow: 0 0 12px rgba(34, 197, 94, .8);
    }

    h1 {
      margin: 22px 0 10px;
      font-size: clamp(42px, 8vw, 76px);
      line-height: .95;
      letter-spacing: -.055em;
    }

    .gradient {
      background: linear-gradient(90deg, #f8fafc, #7dd3fc 45%, #a5b4fc);
      -webkit-background-clip: text;
      background-clip: text;
      color: transparent;
    }

    .subtitle {
      max-width: 680px;
      margin: 0;
      color: var(--muted);
      font-size: 18px;
      line-height: 1.7;
    }

    .grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 14px;
      margin-top: 32px;
    }

    .card {
      padding: 22px;
      border: 1px solid var(--panel-border);
      border-radius: 18px;
      background: rgba(2, 6, 23, .3);
    }

    .card strong { display: block; margin-bottom: 7px; font-size: 14px; }
    .card span { color: var(--muted); font-size: 14px; line-height: 1.6; }

    .footer {
      display: flex;
      justify-content: space-between;
      gap: 16px;
      flex-wrap: wrap;
      margin-top: 28px;
      padding-top: 20px;
      border-top: 1px solid var(--panel-border);
      color: var(--muted);
      font-size: 13px;
    }

    .endpoint {
      color: #bae6fd;
      font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    }

    @media (max-width: 760px) {
      .hero { padding: 30px 22px; border-radius: 22px; }
      .grid { grid-template-columns: 1fr; }
      .subtitle { font-size: 16px; }
    }
  </style>
</head>
<body>
  <main class="container">
    <section class="hero">
      <div class="badge"><span class="dot"></span> Application online</div>
      <h1><span class="gradient">RetailEdge</span></h1>
      <p class="subtitle">
        Cloud-ready retail application running on AWS. This sandbox deployment
        demonstrates the application, networking, compute, data, monitoring,
        and CI/CD layers of the RetailEdge migration project.
      </p>

      <div class="grid">
        <div class="card">
          <strong>Application</strong>
          <span>Python HTTP service running on port 8080.</span>
        </div>
        <div class="card">
          <strong>Health Check</strong>
          <span>ALB-compatible endpoint: <span class="endpoint">/health</span></span>
        </div>
        <div class="card">
          <strong>Platform</strong>
          <span>Amazon EC2 behind the RetailEdge load-balancing layer.</span>
        </div>
      </div>

      <div class="footer">
        <span>RetailEdge AWS Migration • Sandbox</span>
        <span>UTC: {{TIMESTAMP}}</span>
      </div>
    </section>
  </main>
</body>
</html>
"""


class Handler(BaseHTTPRequestHandler):
    def send_common_headers(self, content_type, content_length):
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(content_length))
        self.send_header("Cache-Control", "no-store")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.send_header("X-Frame-Options", "DENY")
        self.send_header("Referrer-Policy", "no-referrer")

    def send_body(self, status_code, body, content_type):
        self.send_response(status_code)
        self.send_common_headers(content_type, len(body))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        if self.path == "/health":
            self.send_body(200, b"OK", "text/plain; charset=utf-8")
            return

        if self.path == "/info":
            payload = {
                "application": "RetailEdge",
                "environment": "sandbox",
                "status": "healthy",
                "port": PORT,
                "timestamp_utc": datetime.now(timezone.utc).isoformat(),
            }
            body = json.dumps(payload, indent=2).encode("utf-8")
            self.send_body(200, body, "application/json; charset=utf-8")
            return

        timestamp = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC")
        body = HTML.replace("{{TIMESTAMP}}", timestamp).encode("utf-8")
        self.send_body(200, body, "text/html; charset=utf-8")

    def log_message(self, format, *args):
        print(f"[RetailEdge] {format % args}")


if __name__ == "__main__":
    server = ThreadingHTTPServer((HOST, PORT), Handler)
    print(f"RetailEdge application listening on {HOST}:{PORT}")
    server.serve_forever()
