FROM python:3.9-alpine3.13

# Specify the person maintaining the docker image
LABEL maintainer="jessywang"

# Recommended when running Python in docker
# Tell Python not to buffer the output. The output from Python will be printed directly to the console, preventing any delays of messages from Python running applications to the screen
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./app /app
# Set the default directory that our command runs from
WORKDIR /app
EXPOSE 8000

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    rm -rf /tmp && \
    # Create a new user to avoid using the root user
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Ensure all code are executed from the virtual environment
ENV PATH="/py/bin:$PATH"

USER django-user


