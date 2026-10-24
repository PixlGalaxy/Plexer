# === Stage 1: Build frontend ===
FROM node:24-alpine AS frontend-build
WORKDIR /frontend
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/ .
RUN npm run build

# === Stage 2: Build backend ===
FROM node:24-alpine AS backend-build
WORKDIR /backend
COPY backend/package*.json ./
RUN npm ci
COPY backend/ .
RUN npm run build

# === Stage 3: Final image ===
FROM qmcgaw/gluetun:v3.41.3 AS runtime
LABEL org.opencontainers.image.source="https://github.com/PixlGalaxy/Plexxer"
LABEL org.opencontainers.image.description="Secure torrent webapp under WireGuard VPN with frontend and backend."

# Instala Node (para correr backend + servir frontend estático)
RUN apk add --no-cache nodejs npm wget

# Copiamos los builds
WORKDIR /app
COPY --from=frontend-build /frontend/dist ./frontend
COPY --from=backend-build /backend/dist ./backend
COPY backend/package.json ./backend/package.json

# Configura variables de entorno
ENV PORT=8080
ENV NODE_ENV=production
ENV MOVIES_PATH=/data/Movies
ENV TVSHOWS_PATH=/data/TvShows

# Copiamos entrypoint
COPY <<'EOF' /app/start.sh
#!/bin/sh
echo "[INFO] Waiting for VPN to be ready..."
until wget -qO- https://ipinfo.io/ip >/dev/null 2>&1; do
  echo "VPN not ready, retrying in 5s..."
  sleep 5
done
echo "[OK] VPN active."
echo "[INFO] Starting backend..."
node /app/backend/index.js &
echo "[INFO] Serving frontend..."
npx serve -s /app/frontend -l 5173
EOF

RUN chmod +x /app/start.sh

EXPOSE 5173
EXPOSE 8080
CMD ["/app/start.sh"]
