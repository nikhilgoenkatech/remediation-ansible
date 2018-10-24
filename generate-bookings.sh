#!/bin/bash
echo "Press [CTRL+C] to stop.."

bookingUrl=http://backend-v2-ticketmonster.18.194.120.69.xip.io/rest/bookings/
statusUrl=http://backend-v2-ticketmonster.18.194.120.69.xip.io/rest/bot/status

# delete all bookings so far
 curl -X PUT -H "Content-Type: application/json" -d "\"RESET\"" $statusUrl
sleep 1

i=0
while true
do
  echo ""
  echo "ordering a ticket..."
  curl -X POST -H "Content-Type: application/json" -d "{\"ticketRequests\":[{\"ticketPrice\":1,\"quantity\":1}],\"email\":\"foo@bar.coom\",\"performance\":1}" $bookingUrl
  i=$((i+1))
  # delete all tickets if more than 100 already booked by this script
  if [ $i -gt 100 ]  
  then 
    echo ""
    echo "delete all tickets ordered so far..."
    curl -X PUT -H "Content-Type: application/json" -d "\"RESET\"" $statusUrl
    let i=0
  fi
  sleep 1
done
