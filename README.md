# Video Generation API (Cloud Run + FastAPI + MoviePy)

This microservice accepts multiple image files and returns a generated MP4 video.
It is designed to be called from n8n.cloud or any automation platform.

## Endpoint

### POST /create-video
Send a multipart/form-data request containing multiple images:

