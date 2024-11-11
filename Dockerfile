# Stage 1: Build the React app
# FROM node:16 AS build
# Stage 1: Build the React app with a lightweight Node image
# FROM node:16-alpine AS build
FROM node:16-slim AS build

# Set working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json, then install dependencies
COPY package*.json ./

# Clean up existing node_modules and package-lock.json (if any)
RUN rm -rf node_modules package-lock.json

RUN npm install --timeout=600000

# Install only production dependencies
RUN npm --default-timeout=1000 install --production

# Copy the rest of the React app files to the container
COPY . .

RUN npm install @rollup/rollup-linux-x64-gnu

# Build the React app
RUN npm run build

# Stage 2: Serve the React app with a lightweight web server
# FROM nginx:alpine
FROM nginx:1.27.2-alpine-slim

# Copy the build output from the first stage to the NGINX public directory
# COPY --from=build /app/build /usr/share/nginx/html
# Copy the build output from the first stage to the NGINX public directory
COPY --from=build /app/dist /usr/share/nginx/html


# Expose port 80
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
# ##############################
# to build it we run: docker build -t my-react-app .
# docker build --timeout=1000 -t my-react-app .
# to run it we run: docker run -p 80:80 my-react-app
# to run it we run: docker run -p 5173:80 my-react-app
# or : docker run -d -p 80:80 my-react-app
# #############################docker push###########
# docker tag local-image:tagname new-repo:tagname
# docker tag my-react-app:latest berobee/earthquake_prediction_images:latest
#  docker push new-repo:tagname
#  docker push berobee/earthquake_prediction_images:latest
