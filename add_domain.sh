cat domains.txt | cut -c1-9 > cutdomains.txt
rm domains.txt
mv cutdomains.txt domains.txt
for domain in $(cat domains.txt); 
do \
  curl -X POST -H "X-Auth-Key: $KEY" -H "X-Auth-Email: $EMAIL" \
  -H "Content-Type: application/json" \
  "https://api.cloudflare.com/client/v4/zones" \
  --data '{"account": {"id": "'"$ID"'"}, "name":"'$domain'","jump_start":false}'
	echo -e "\n"
	


#sleep 3 & PID=$! #simulate a long process

#echo "Killing time to allow domains to show up as registered this takes about 3 seconds "
#printf "["
# While process is running...
#while kill -0 $PID 2> /dev/null; do 
#    printf  "▓"
#    sleep 1
#done
#printf "] done! \n \n \n"; 
done
read -p '************************Are all domains properly registered?************************ [Y | N]: ' ans
case $ans in

	Y | y) echo "Proceeding to DNS registration"
		 sleep 1
		 bash get_zone.sh
		 ;;
	N | n) read -n 1 -r -s -p "Fix domain list. Press any key to run adder again"
		 sleep 1
		 bash add_domain.sh
		 ;;
	*) read -n 1 -r -s -p "wat"
		 sleep 1
		 bash add_domain.sh
		 ;;
esac
