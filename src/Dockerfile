FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    FLASK_ENV=production

# Create a non-root user
RUN useradd -m appuser

# Set working directory
WORKDIR /app

# Install dependencies
COPY app.py requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt \
 && chown -R appuser:appuser /app \
 && apt-get purge -y --auto-remove \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 5000

# Start the service with Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
