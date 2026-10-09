FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .

# Build-time variable. Containify passes the app variable with the same name
# as a build arg, and the dashboard tags it "build".
ARG PUBLIC_API_URL=http://localhost:3000
ENV PUBLIC_API_URL=$PUBLIC_API_URL

RUN npm run build && npm prune --omit=dev

FROM node:20-alpine
WORKDIR /app
COPY --from=build /app/build ./build
COPY --from=build /app/node_modules ./node_modules
COPY package.json ./
ENV PORT=3000
EXPOSE 3000
CMD ["node", "build/index.js"]
