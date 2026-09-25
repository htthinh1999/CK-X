FROM node:18-alpine

WORKDIR /app
COPY server.js ./

# Talks to the Docker socket, so it runs as root. It is internal-only (no
# published ports) and only recreates the services listed in RESET_SERVICES.
EXPOSE 3000
CMD ["node", "server.js"]
