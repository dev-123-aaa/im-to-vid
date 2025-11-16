FROM python:3.11-slim

# Install FFmpeg
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app
COPY server.py /app/server.py
WORKDIR /app

# Expose port 8080 (Cloud Run default)
EXPOSE 8080

# Start FastAPI via Uvicorn
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8080"]
