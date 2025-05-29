FROM debian:bullseye

RUN apt update -y && apt upgrade -y && \
    apt install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes \
    -days 365 \
    -keyout /etc/nginx/ssl/ibenaiss.42.fr.key \
    -out /etc/nginx/ssl/ibenaiss.42.fr.crt \
    -subj "/CN=ibenaiss.42.fr"

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/wordpress /var/run/nginx && \
    chmod 755 /var/www/wordpress && \
    chown -R www-data:www-data /var/www/wordpress

EXPOSE 80

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]