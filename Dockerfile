# Stage 1: Build Stage

# Use the official Python slim image as the base image
FROM python:3.8-slim as builder

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the current work directory
WORKDIR /app

# Install dependencies
COPY ./requirements.txt .

RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r requirements.txt


# Stage 2: Production Stage

# Pull the official base image
FROM python:3.8-slim

# Create a directory for the app user
RUN mkdir -p /home/app

# Create a non-root user and group with explicit IDs
RUN addgroup --system docker --gid 1001 \
    && adduser --system --ingroup docker --uid 1001 docker

# Create the appropriate directories
WORKDIR /app

# Copy requirements
COPY --from=builder /app/wheels /wheels

# Install dependencies using wheels
RUN pip install --upgrade pip && pip install --no-cache /wheels/*

# Copy the entire project
COPY . /app/

# Change ownership of all the files to the app user
RUN chown -R docker:docker /app/

# Change to the app user
USER docker

# Specify the command to run the application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
