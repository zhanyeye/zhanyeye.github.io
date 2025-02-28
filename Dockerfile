FROM nginx:latest
COPY default.conf /etc/nginx/conf.d/default.conf
COPY public/ /usr/share/nginx/html/

CMD exec nginx -g 'daemon off;'