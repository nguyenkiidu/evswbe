echo "Symlinking shared paths"
if [ -L /root/eventswish-backend/current/public ] ; then
    unlink /root/eventswish-backend/current/public
else
    sudo rm -rf /root/eventswish-backend/current/public
fi

if [ -d /root/eventswish-backend/current/tmp/ ]; then
    sudo rm -rf /root/eventswish-backend/current/tmp/
fi

ln -rsfn /root/eventswish-backend/shared/public/ /root/eventswish-backend/current/public
ln -rsfn /root/eventswish-backend/shared/tmp/ /root/eventswish-backend/current/tmp


echo "Restarting server..."
echo "The server 'll use $ENVIRONMENT env"

cd /root/eventswish-backend/current && docker-compose -f docker-compose.production.yaml build
cd /root/eventswish-backend/current && docker-compose -f docker-compose.production.yaml up -d
