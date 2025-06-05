# Use Python base image
FROM python:3.11

# Set working directory
WORKDIR /usr/src/app

# Copy Python requirements and install
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN python -m pip install --upgrade pip

# Copy the rest of your app source code
COPY . .

# Expose the port your Flask app runs on
EXPOSE 5000

# Start the Flask application (change run.py to your main file if needed)
CMD ["python", "run.py"]
