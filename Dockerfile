FROM python:3.11-slim

# Install FFmpeg and moviepy dependencies
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libsm6 \
    libxext6 \
    libxrender1 \
    libgl1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt

# Copy FastAPI app
COPY server.py /app/server.py

# Cloud Run expects app to listen on $PORT
ENV PORT=8080
EXPOSE 8080

# Start FastAPI app
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8080"]
