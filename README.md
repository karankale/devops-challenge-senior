# SimpleTimeService

A lightweight Python microservice that returns the current UTC timestamp and the IP address of the caller in JSON format.

Built with:
-  Flask (Python 3.12)
-  Gunicorn (for production-ready serving)
-  Docker (multi-stage optimized build)
-  GitHub Actions CI/CD (build, scan, sign, deploy)
-  Terraform (EKS infrastructure as code)

---

## API Output

When you hit the root `/` endpoint:

```json
{
  "timestamp": "2025-04-14T08:12:05.123Z",
  "ip": "192.168.1.100"
}
