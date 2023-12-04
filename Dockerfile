# Use an official Python 3.9 image based on Windows Server Core
FROM python:3.9-windowsservercore

LABEL maintainer="***"

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
RUN powershell -Command "\
    python -m venv C:\py ; \
    C:\py\Scripts\pip install --upgrade pip ; \
    C:\py\Scripts\pip install -r C:\tmp\requirements.txt ; \
    if ($env:DEV -eq 'true') { \
        C:\py\Scripts\pip install -r C:\tmp\requirements.dev.txt ; \
    } ; \
    Remove-Item -Path C:\tmp -Recurse -Force ; \
    Add-User -DisabledPassword -NoCreateHome -UserName django-user"

# Switch to the 'django-user' user
USER ContainerAdministrator
