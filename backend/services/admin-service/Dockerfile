FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o admin-service .

FROM alpine:latest

WORKDIR /root/

COPY --from=builder /app/admin-service .

ENV PORT=3009

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:3009/health || exit 1

EXPOSE 3009

CMD ["./admin-service"]
