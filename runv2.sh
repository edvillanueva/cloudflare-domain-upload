#!/bin/bash
#cat unregistered.txt | grep "not a registered domain" | cut -f5 -d":" | cut -c2-10 | tee domains.txt

login() 
{
read -p 'Enter EMAIL ADDRESS: ' EMAIL
read -p 'Enter API KEY: ' KEY
read -p 'Enter ID: ' ID
read -p 'Point to what IP?: ' IP
read -p 'Enter CNAME Value: ' CNAME
read -p 'Enter UPDOWN API key': UPDOWNAPI

export EMAIL="$EMAIL"
export KEY="$KEY"
export ID="$ID"
export IP="$IP"
export CNAME="$CNAME"
export UPDOWNAPI="$UPDOWNAPI"

read -p 'Backspace blankspace / Last char from txt file? [y | n | u | h]
 
y = Yes
n = No

e = Skip to HTTPS enabling
u = Pass domains to Updown.io only
h = Reissue SSL Certificates

Choice selected: ' ans
case $ans in

	Y | y) echo -e "deleting last char\n"
		sed 's/.$//' domains.txt > cutdomains.txt #DELETES LAST CHAR
		rm domains.txt
		cp cutdomains.txt updowndom.txt
		mv cutdomains.txt domains.txt
		add_domain
		;;
	N | n) echo -e "proceeding to add domain\n"
		cp domains.txt updowndom.txt		
		add_domain
		;;
	U | u) echo -e "Loading it to updown.io \n"
		cp domains.txt updowndom.txt
		bash updown.sh
		;;
	H | h) echo -e "Reissuing SSL certificates \n"
		cp domains.txt updowndom.txt		
		get_zone
		set_https_off
		set_https
		;;
	E | e) echo -e "Skipping to enable https part on domains list"
		cp domains.txt updowndom.txt		
		get_zone
		set_https
		;;
	*) read -n 1 -r -s -p "wat"
		add_domain
		;;
esac
}

add_domain()
{
for domain in $(cat domains.txt); do \
  curl -X POST -H "X-Auth-Key: $KEY" -H "X-Auth-Email: $EMAIL" \
  -H "Content-Type: application/json" \
  "https://api.cloudflare.com/client/v4/zones" \
  --data '{"account": {"id": "'"$ID"'"}, "name":"'$domain'","jump_start":false}'
	echo -e "\n" 

done
toilet -f future -F gay "ATTENTION"
read -p '************************Are all domains properly registered?************************ [Y | N]: ' ans
case $ans in

	Y | y) echo "Proceeding to DNS registration"
		 get_zone
		 dns_point
		 cname_enter
		 set_https
		 ;;
	N | n) 	echo "Running adder again with domain list fixed"
		 add_domain
		 ;;
	*) read -n 1 -r -s -p "wat"
		 add_domain
		 ;;
esac
}

get_zone()
{
curl -s -X GET "https://api.Cloudflare.com/client/v4/zones/?per_page=100" -H "X-Auth-Email: $EMAIL" -H "X-Auth-Key: $KEY" -H "Content-Type: application/json"| jq -r '.result[] | "\(.id)"' >  "zoneid.txt"

echo -e "\nZone IDS generated"
sleep 1
}

#DISABLED DUE TO REMOVAL OF FREENOM SUPPORT
dns_point()
{
echo "Now pointing domains with DNS records to "$IP"";
echo "Beginning to point domains to IP address"

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

echo "Proceeding to enable CNAME in domains"
}

#DISABLED DUE TO REMOVAL OF FREENOM SUPPORT
cname_enter()
{
echo "Now pointing domains with DNS records to "$CNAME"";
echo "Beginning to add CNAME records"

for zoneid in $(cat zoneid.txt); do \
EMAIL="$EMAIL"; \
KEY="$KEY"; \
ZONE_ID="$zoneid"; \
TYPE="CNAME"; \
NAME="T"; \
CONTENT="$CNAME"; \
PROXIED="true"; \
TTL="1"; \
curl -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/" \
    -H "X-Auth-Email: $EMAIL" \
    -H "X-Auth-Key: $KEY" \
    -H "Content-Type: application/json" \
    --data '{"type":"'"$TYPE"'","name":"'"$NAME"'","content":"'"$CONTENT"'","proxied":'"$PROXIED"',"ttl":'"$TTL"'}' \
    | python -m json.tool ;done

echo "Proceeding to enable HTTPS"
}

set_https_off()
{
for zoneid in $(cat zoneid.txt); do \
ZONE_ID="$zoneid"; \
curl -X PATCH "https://api.cloudflare.com/client/v4/zones/"$ZONE_ID"/settings/always_use_https" \
     -H "X-Auth-Email: $EMAIL" \
     -H "X-Auth-Key: $KEY" \
     -H "Content-Type: application/json" \     
     --data '{"value":"off"}'
echo -e "\n" ;done
echo "SSL certificates are now turned off and will be reissued"
}

#PLEASE NOTE SET_HTTPS_OFF AND SET_HTTPS_ON ARE DIFFERENT COMMANDS

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
echo "This batch is complete. Proceeding to check for errors."
bash updown.sh
login
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

login
