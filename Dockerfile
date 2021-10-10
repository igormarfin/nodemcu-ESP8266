FROM mhart/alpine-node:10


WORKDIR /app


# If possible, run your container using `docker run --init`
# Otherwise, you can use `tini`:
RUN apk add --no-cache tini

COPY package.json /app

# --no-cache: download package index on-the-fly, no need to cleanup afterwards
# --virtual: bundle packages, remove whole bundle at once, when done
RUN apk --no-cache --virtual build-dependencies add \
    make \
    python \
    linux-headers \
    udev \
    g++ \
    && npm install  \
    && apk del build-dependencies



ENTRYPOINT ["/sbin/tini", "--"]
