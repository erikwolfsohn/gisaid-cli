FROM python:3.7 as app

LABEL base.image="python:3.7"
LABEL container.version="1.0.0"
LABEL software="GISAID CLI Uploader"
LABEL software.version="3.0.0"
LABEL maintainer "Erik Wolfsohn <erik.wolfsohn@cchealth.org>"

WORKDIR /opt/gisaid

RUN wget https://codeload.github.com/erikwolfsohn/gisaid-cli/zip/refs/heads/main &&\
	unzip /opt/gisaid/main &&\
	cd /opt/gisaid/gisaid-cli-main/gisaid_cli3 &&\
	pip3 install .


CMD ["/bin/bash"]

FROM app as test

RUN cli3 -h