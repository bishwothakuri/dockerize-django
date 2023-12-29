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

# Install PostgreSQL client tools and ncat for network connectivity checks
RUN apt-get update && apt-get install -y postgresql-client ncat

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

# copy entrypoint.sh
COPY ./docker/entrypoint.sh .
RUN sed -i 's/\r$//g'  entrypoint.sh

# Grant execute permission to the entrypoint script
RUN chmod +x entrypoint.sh

# Copy the entire project
COPY . /app/

# Change ownership of all the files to the app user
RUN chown -R docker:docker /app/

# Change to the app user
USER docker

# run entrypoint
ENTRYPOINT ["./entrypoint.sh"]
CMD [ "run_devcolumn" ]

EXPOSE 8000

