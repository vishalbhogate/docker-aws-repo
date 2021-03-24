FROM tbrock/saw:v0.2.2 as saw


FROM alpine:3.11

ENV BOTO3_VERSION=1.14.2
ENV BOTOCORE_VERSION=v2.tar.gz
ENV AWSCLI_VERSION=2.1.6.tar.gz

RUN apk --no-cache update && \
    apk --no-cache add \
        python3-dev \
        libffi-dev \
        openssl-dev \
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
    pip3 --no-cache-dir install --upgrade pip==20.2.1 setuptools==46.1.3 && \
    pip3 --no-cache-dir install boto3==$BOTO3_VERSION \
                                https://github.com/boto/botocore/archive/$BOTOCORE_VERSION \
                                https://github.com/aws/aws-cli/archive/$AWSCLI_VERSION && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*

COPY --from=saw /bin/saw /bin/saw

COPY scripts /opt/scripts

ENV PATH "$PATH:/opt/scripts"

WORKDIR /work

ENTRYPOINT [ "aws" ]

CMD [ "--version" ]
