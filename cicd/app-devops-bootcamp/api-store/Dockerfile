FROM node:14-alpine AS build 
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build 

FROM nginx:mainline-alpine-slim AS production 
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


#docker build -t backend-devops:v3 .
#docker run -p 80:80 backend-devops:v3