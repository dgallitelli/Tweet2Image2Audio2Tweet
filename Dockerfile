FROM alpine:latest

# Update the image and install python3 and pip
RUN apk update && apk upgrade &&\
    apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

# Copy the script
COPY Billboard.py script.py
# Copy the necessary html files
COPY html ./html
# Copy example image
COPY images/quote.jpg .
    
# Install the dependencies
COPY tweepy ./tweepy
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Setup environment variables for script global vars
ENV AWS_ACCESS_KEY_ID="" AWS_SECRET_ACCESS_KEY=""
ENV REGION="eu-west-1" BUCKET="" FOLDER=""
ENV TWIT_USER=""
ENV TWIT_CONS_KEY="" TWIT_CONS_SECRET=""
ENV TWIT_ACCESS_KEY="" TWIT_ACCESS_SECRET=""
ENV DEBUG="False"

ENTRYPOINT python script.py