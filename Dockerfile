# Use Python 3.11 slim as base image
FROM python:3.11-slim

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV FLASK_ENV=production

# Copy requirements file and install dependencies
COPY requirements_back4app.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the project files
COPY . .

# Create uploads directory
RUN mkdir -p uploads/gallery static/uploads/gallery

# Expose the server port
EXPOSE 8080

# Start Gunicorn with optimized settings for Back4App
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8080", "--timeout", "120", "--keep-alive", "5", "main:app"]