# --- STAGE 1: Build the React App ---
FROM node:24-alpine AS build

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci

# Copy the rest of the application code and build it
COPY . .
RUN npm run build

# --- STAGE 2: Serve the App with Nginx ---
FROM nginx:1.25-alpine

# Copy the compiled static files from Stage 1 over to Nginx's HTML folder
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 so we can access the app
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]