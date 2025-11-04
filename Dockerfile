FROM alpine:3.19
RUN apk add --no-cache python3
WORKDIR /app
COPY build.sh .
RUN chmod +x build.sh
CMD ["sh", "-c", "./build.sh"]
