FROM tbrock/saw:v0.2.2 as saw


FROM alpine:3.11

ENV BOTOCORE=1.17.2
ENV BOTO3_VERSION=1.14.2
ENV AWSCLI_VERSION=1.18.79

RUN apk --no-cache update && \
    apk upgrade && \
    apk --no-cache add \
        python3 \
        py3-pip \
        python3-dev \
        ca-certificates \
        groff \
        less \
        bash \
        make \
        jq \
        gettext-dev \
        wget \
        curl \
        g++ \
        zip \
        git  && \
    pip3 --no-cache-dir install --upgrade pip setuptools && \
    pip3 --no-cache-dir install botocore boto3 awscli==$AWSCLI_VERSION && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*

COPY --from=saw /bin/saw /bin/saw

COPY scripts /opt/scripts

ENV PATH "$PATH:/opt/scripts"

WORKDIR /work

ENTRYPOINT [ "aws" ]

CMD [ "--version" ]
