# Auth Service Dockerfile
FROM golang:1.21-alpine AS builder

WORKDIR /build

COPY go.* ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o auth-service main.go

# Production image
FROM alpine:3.18

RUN apk add --no-cache ca-certificates

WORKDIR /app

COPY --from=builder /build/auth-service .

EXPOSE 8001

CMD ["./auth-service"]
