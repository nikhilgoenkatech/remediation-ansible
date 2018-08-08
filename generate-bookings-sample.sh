#!/bin/bash
echo "Press [CTRL+C] to stop.."
while true
do
  echo ""
  echo "ordering a ticket..."
  curl -X POST -H "Content-Type: application/json" -d "{\"ticketRequests\":[{\"ticketPrice\":1,\"quantity\":1}],\"email\":\"foo@bar.coom\",\"performance\":1}" http://backend-v2-PROJECT.YOURURL.COM/rest/bookings/
	sleep 1
done
