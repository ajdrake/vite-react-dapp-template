# Build Stage
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install --frozen-lockfile

# Copy the rest of the application
COPY . .

# Build the React app
RUN npm run build && ls -la /app/dist

# Serve Stage
FROM nginx:alpine

# Remove default index page (fix potential conflicts)
RUN rm -rf /usr/share/nginx/html/*

# Copy built React app to Nginx public folder
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 (this is what DigitalOcean expects)
EXPOSE 80

# Health Check (Ensures Nginx is running)
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -f http://localhost || exit 1

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]