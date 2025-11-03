FROM alpine:3.19
COPY build.sh /app/build.sh
WORKDIR /app
RUN chmod +x build.sh
CMD ["sh", "-c", "./build.sh && tail -f /dev/null"]
