FROM node:latest as markdown-converter

RUN npm install -g markdown-styles

COPY script.md input/index.md

RUN generate-md --layout github --input ./input -output ./output

FROM nginx:alpine as nginx

COPY --from=markdown-converter ./output /usr/share/nginx/html
