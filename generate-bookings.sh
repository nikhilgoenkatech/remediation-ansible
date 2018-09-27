#!/bin/bash
echo "Press [CTRL+C] to stop.."
i=0
while true
do
  echo ""
  echo "ordering a ticket..."
  curl -X POST -H "Content-Type: application/json" -d "{\"ticketRequests\":[{\"ticketPrice\":1,\"quantity\":1}],\"email\":\"foo@bar.coom\",\"performance\":1}" http://backend-v2-ticketmonster.18.194.120.69.xip.io/rest/bookings/
  i=$((i+1))
  # delete all tickets if more than 100 already booked by this script
  if [ $i -gt 100 ]  
  then 
    echo "delete all tickets ordered so far..."
    curl -X PUT -H "Content-Type: application/json" -d "\"RESET\"" http://monolith-ticketmonster.18.194.120.69.xip.io/rest/bot/status
    let i=0
  fi
  sleep 1
done
