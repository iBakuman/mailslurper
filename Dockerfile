FROM golang:1.18.1-alpine3.15 as builder

LABEL maintainer="erguotou525@gmail.compute"

RUN apk --no-cache add git libc-dev gcc
RUN go install github.com/mjibson/esc@latest # TODO: Consider using native file embedding

COPY . /go/src/github.com/mailslurper/mailslurper
WORKDIR /go/src/github.com/mailslurper/mailslurper/cmd/mailslurper

RUN go get
RUN go generate
RUN go build

FROM alpine:3.15

RUN apk add --no-cache ca-certificates jq

WORKDIR /app

COPY --from=builder /go/src/github.com/mailslurper/mailslurper/cmd/mailslurper/mailslurper .
COPY ./config.json .
COPY ./script/entrypoint.sh .
RUN chmod +x entrypoint.sh

EXPOSE 4436 4437 1025

CMD ["./entrypoint.sh"]
