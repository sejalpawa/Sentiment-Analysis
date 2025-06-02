# Use Python base image
FROM python:3.11

# Set working directory
WORKDIR /usr/src/app

# Copy Python requirements and install
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Install Node.js and Playwright for scraping
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    npm install -g npm@latest && \
    npm install playwright && \
    npx playwright install firefox

# Copy the rest of your app source code
COPY . .

# Expose the port your Flask app runs on (adjust if needed)
EXPOSE 3000

# Start the Flask application
CMD ["python", "run.py"]
