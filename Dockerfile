FROM python:3.11-slim

# Install system deps
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libsm6 \
    libxext6 \
    libxrender1 \
    libgl1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY server.py .

# Ensure PORT env
ENV PORT=8080
EXPOSE 8080

# Run Uvicorn
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8080"]
