# Use an official Python 3.9 image based on Windows Server Core
FROM python:3.9.18-alpine3.18


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

# ARG directive should be defined before any RUN directives
ARG DEV=false


# Create a virtual environment, install dependencies, and set up the environment
RUN python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /venv/bin/pip install -r /tmp/requirements.dev.txt; fi


# Create a user named 'django-user' (or any other name you prefer)
RUN adduser -D django-user

# Switch to the 'django-user' user
USER django-user

# Command to run the application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
