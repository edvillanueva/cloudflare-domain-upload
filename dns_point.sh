echo "Now pointing domains with DNS records to "$IP"";

sleep 3 & PID=$! #simulate a long process

echo "Beginning to point domains to IP address"
printf "["
# While process is running...
while kill -0 $PID 2> /dev/null; do 
    printf  "▓"
    sleep 1
done
printf "] done! \n \n \n" done

for zoneid in $(cat zoneid.txt); do \
EMAIL="$EMAIL"; \
KEY="$KEY"; \
ZONE_ID="$zoneid"; \
TYPE="A"; \
NAME="@"; \
CONTENT="$IP"; \
PROXIED="true"; \
TTL="1"; \
curl -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/" \
    -H "X-Auth-Email: $EMAIL" \
    -H "X-Auth-Key: $KEY" \
    -H "Content-Type: application/json" \
    --data '{"type":"'"$TYPE"'","name":"'"$NAME"'","content":"'"$CONTENT"'","proxied":'"$PROXIED"',"ttl":'"$TTL"'}' \
    | python -m json.tool ;done


read -n 1 -r -s -p "Press enter key to proceed to enable HTTPS"
bash page_rule.sh

