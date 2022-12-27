FROM golang:1.18 as builder
WORKDIR /app
COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o lura server.go

FROM alpine:latest
WORKDIR /app
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/config.json /app/
COPY --from=builder /app/lura /app/
ENTRYPOINT ["./lura"]