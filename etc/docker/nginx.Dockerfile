FROM debian:bullseye-slim
RUN apt-get update -y
RUN apt-get install -y nginx certbot python3-certbot-nginx cron
COPY etc/nginx/nginx.conf .
COPY scripts/nginx-entrypoint.sh .
RUN chmod +x ./nginx-entrypoint.sh
ENTRYPOINT ["./nginx-entrypoint.sh"]