# Use Python as the base, a slim version to keep it small
FROM python:3.10-slim

# Set the working directory inside the container to /app
WORKDIR /app

# Copy the file that lists all your Python packages
COPY requirements.txt .

# Install the Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code
COPY . .

# Let Docker know that this app will use port 5000
EXPOSE 5000

# Command to start your application
CMD ["python", ""ece_792_project_attention.py""]
