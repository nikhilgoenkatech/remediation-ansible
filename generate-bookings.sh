#!/bin/bash
echo "Press [CTRL+C] to stop.."
while true
do
  echo ""
  echo "ordering a ticket..."
  curl -X POST -H "Content-Type: application/json" -d "{\"ticketRequests\":[{\"ticketPrice\":1,\"quantity\":1}],\"email\":\"foo@bar.coom\",\"performance\":1}" http://backend-v2-ws8.18.207.174.41.xip.io/rest/bookings/
	sleep 1
done
