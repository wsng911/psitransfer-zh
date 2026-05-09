FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache git tzdata && \
    git config --global user.email "dev@example.com" && \
    git config --global user.name "dev"

COPY package*.json ./
RUN npm install --production

COPY app/package*.json ./app/
RUN cd app && NODE_ENV=dev npm install

COPY . .

RUN git init && git add -A && git commit -m "init" || true

RUN cd app && npm run build && cd .. && rm -rf app/node_modules

ENV PSITRANSFER_UPLOAD_DIR=/data
ENV NODE_ENV=production

RUN mkdir -p /data && chown node /data

EXPOSE 3000

VOLUME ["/data"]

USER node

CMD ["node", "app.js"]
