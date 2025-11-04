#!/bin/sh
echo "🚀 Starting simple web server..."
python3 -m http.server 80 &
echo "✅ Web server started in background!"
tail -f /dev/null
