FROM alpine:3.19
COPY build.sh /app/build.sh
WORKDIR /app
RUN chmod +x build.sh

# Jalankan script & biar container tetap hidup
CMD ["sh", "-c", "./build.sh && tail -f /dev/null"]

# ✅ Healthcheck setiap 10 detik, timeout 3 detik, gagal setelah 3x gagal
HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD ps aux | grep build.sh || exit 1
