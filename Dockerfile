FROM python:3.9-alpine3.13

# Specify the person maintaining the docker image
LABEL maintainer="jessywang"

# Recommended when running Python in docker
# Tell Python not to buffer the output. The output from Python will be printed directly to the console, preventing any delays of messages from Python running applications to the screen
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
# Set the default directory that our command runs from
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    # Install the postgresql-client. Required for Psycopg2 (Postgresql adaptor)
    apk add --update --no-cache postgresql-client && \ 
    # Sets a virutal dependency package. Groups the packages installed 
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev &&\
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi &&\
    rm -rf /tmp && \
    apk del .tmp-build-deps &&\
    # Create a new user to avoid using the root user
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Ensure all code are executed from the virtual environment
ENV PATH="/py/bin:$PATH"

USER django-user


