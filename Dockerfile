# Use an official Python 3.9 image based on Windows Server Core
FROM python:3.9-alpine3.13

LABEL maintainer="ibadathossain"

ENV PYTHONUNBUFFERED 1

# Copy requirements files to /tmp in the container
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy the application code into the container
COPY ./app /app

# Set the working directory
WORKDIR /app

# Expose any necessary ports (this is a documentation feature in Windows containers)
EXPOSE 8000

ARG DEV=false

# Create a virtual environment, install dependencies, and set up the environment
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Specify the full path to flake8 executable
CMD ["/py/bin/flake8"]



ENV PATH="/py/bin:$PATH"

USER django-user