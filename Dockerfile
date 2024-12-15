FROM python:3.11

# Install system dependencies for MySQL

# Set the working directory
WORKDIR /app

# Install dependencies
COPY pyproject.toml poetry.lock ./
RUN pip install poetry && poetry install --no-dev

# Copy application code
COPY . /app

# Add a startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose port
EXPOSE 5000

# Set entrypoint
ENTRYPOINT ["poetry", "run", "python", "app.py"]