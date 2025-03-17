# Build Stage
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm install --frozen-lockfile

# Copy the rest of the app
COPY . .

# Ensure the build folder is created
RUN npm run build && ls -la /app/dist

# Serve Stage (Final Image)
FROM nginx:alpine

# Create directory if it does not exist (Kaniko fix)
RUN mkdir -p /usr/share/nginx/html

# Remove default Nginx index page (if needed)
RUN rm -rf /usr/share/nginx/html/*

# Copy built files from previous stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]