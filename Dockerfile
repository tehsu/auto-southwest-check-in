FROM python:3.11.8-alpine3.18

WORKDIR /app

# Define so the script knows not to download a new driver version, as
# this Docker image already downloads a compatible chromedriver
ENV AUTO_SOUTHWEST_CHECK_IN_DOCKER 1

RUN apk add --update --no-cache chromium=119.0.6045.159-r0 chromium-chromedriver=119.0.6045.159-r0

COPY requirements.txt requirements.txt
RUN pip3 install --upgrade pip && pip3 install --no-cache-dir -r requirements.txt

# Manually copy the driver to the correct locations. There is not currently a chromedriver
# that work with Linux ARM, so it needs to be downloaded through apk and copied over. The
# Python directory will need to be updated every time the Python image is updated.
RUN cp /usr/bin/chromedriver /usr/local/lib/python3.12/site-packages/seleniumbase/drivers/chromedriver
RUN cp /usr/bin/chromedriver /usr/local/lib/python3.12/site-packages/seleniumbase/drivers/uc_driver

COPY . .

ENTRYPOINT ["python3", "-u", "southwest.py"]
