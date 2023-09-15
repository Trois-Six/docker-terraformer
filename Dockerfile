FROM golang:1.21-alpine AS build
COPY terraformer-repo/ /tmp/terraformer/
WORKDIR /tmp/terraformer
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go mod tidy && \
    GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go mod download && \
    GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -v -ldflags '-w -s'

FROM alpine:latest
LABEL name=terraformer
WORKDIR /root
COPY --from=build /tmp/terraformer/terraformer /bin/terraformer
ENTRYPOINT [ "/bin/terraformer" ]
