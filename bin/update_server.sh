echo "Restarting server..."
echo "The server 'll use $ENVIRONMENT env"

cd /root/eventswish-backend/current && docker-compose -f docker-compose.production.yaml build
cd /root/eventswish-backend/current && docker-compose -f docker-compose.production.yaml up -d
