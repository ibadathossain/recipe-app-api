# Use an official Python 3.9 image based on slim
FROM python:3.9-slim

LABEL maintainer="ibadathossain"

ENV PYTHONUNBUFFERED 1

# Copy requirements files to /tmp in the container
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy the application code into the container
COPY ./app /app

# Set the working directory
WORKDIR /app

# Expose any necessary ports
EXPOSE 8000

# ARG directive should be defined before any RUN directives
ARG DEV=false

# Create a virtual environment, install dependencies, and set up the environment
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user



# Switch to the 'django-user' user
USER django-user
