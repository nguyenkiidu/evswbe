echo "Restarting server..."
echo "The server 'll use $ENVIRONMENT env"

cd /home/ubuntu/patientbackend/current && docker-compose -f docker-compose.production.yaml build
cd /home/ubuntu/patientbackend/current && docker-compose -f docker-compose.production.yaml up -d
