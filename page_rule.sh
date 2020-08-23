set_https() 
{
for zoneid in $(cat zoneid.txt); do \
ZONE_ID="$zoneid"; \
curl -X PATCH "https://api.cloudflare.com/client/v4/zones/"$ZONE_ID"/settings/always_use_https" \
     -H "X-Auth-Email: $EMAIL" \
     -H "X-Auth-Key: $KEY" \
     -H "Content-Type: application/json" \
     --data '{"value":"on"}' 
echo -e "\n" ;done

echo -e "\nDomains registered - CHECK"
echo "DNS pointed to IP - CHECK"
echo "HTTPS is enabled - CHECK"
read -n 1 -r -s -p "This batch is complete. Press any key to do another batch."
clear
bash login.sh
}

delay() 
{
echo "Beginning countdown to enable page rule [HTTPS]"
for i in {300..01}
	do
	tput cup 10 $l
	echo -n "$i"
	sleep 1
	done
set_https
}

clear
read -p 'Set a 5 min delay for HTTPS registration? [Y | N]:  ' ans
case $ans in

	Y | y) echo "Setting a delay for 5 minutes"
		 sleep 1
		 delay
		 ;;
	N | n) read -n 1 -r -s -p "Beggining immediately"
		 sleep 1
		 set_https
		 ;;
	*) read -n 1 -r -s -p "wat"
		 sleep 1
		 set_https
		 ;;
esac




