FROM golang:1.21.8-alpine as builder

RUN apk --no-cache add git libc-dev gcc && rm -rf /var/cache/api/* \
    && go install github.com/mjibson/esc@latest

WORKDIR /src
COPY . .
ENV CGO_ENABLED=1
RUN go get -d -v ./... && go generate && go build -o /app/mailslurper ./cmd/mailslurper

FROM alpine:3.18

RUN apk add --no-cache ca-certificates jq
WORKDIR /app
COPY --from=builder /app/mailslurper .
COPY ./config/* .
COPY ./script/entrypoint.sh .
RUN chmod +x entrypoint.sh
EXPOSE 4436 4437 1025
CMD ["./entrypoint.sh"]
