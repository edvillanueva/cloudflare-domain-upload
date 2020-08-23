curl -s -X GET "https://api.Cloudflare.com/client/v4/zones/?per_page=100" -H "X-Auth-Email: $EMAIL" -H "X-Auth-Key: $KEY" -H "Content-Type: application/json"| jq -r '.result[] | "\(.id)"' >  "zoneid.txt"

echo -e "\nZone IDS generated"
sleep 1

bash dns_point.sh
