FROM alpine:3.19
COPY build.sh /app/build.sh
WORKDIR /app
RUN chmod +x build.sh
CMD sh -c '
  echo "🏁 Running build script...";
  ./build.sh;
  echo "✅ Build done, keeping container alive";
  tail -f /dev/null
'
