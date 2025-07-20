# Use a specific version for reproducibility
FROM python:3.11.9-alpine3.19

# Set up a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
ENV HOME=/home/appuser
WORKDIR $HOME/app

# Install build dependencies, then Python packages, then remove build deps
COPY requirements.txt .
RUN apk add --no-cache --virtual .build-deps gcc musl-dev libffi-dev openssl-dev && \
    pip install --no-cache-dir -r requirements.txt && \
    apk del .build-deps

# Copy application code
COPY src ./src
# Copy token.json if it exists (optional for OAuth)
COPY token.jso[n] ./

# Create the output directory structure and fix permissions
RUN mkdir -p output/static && chown -R appuser:appgroup $HOME
USER appuser

# Command to run the application
CMD ["python", "src/generate_dashboard.py", "--loop"]