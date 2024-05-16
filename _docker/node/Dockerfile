# Use an official Node.js base image with a specific version
FROM node:20.9-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./
COPY yarn*.lock ./

# Install the application dependencies
RUN yarn install

# Copy the application code to the working directory
COPY . .

# Expose the port on which your application will run
EXPOSE 5173

# Start the Vite server
CMD ["yarn", "dev"]