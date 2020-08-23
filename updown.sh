#!/bin/bash
#use to verify domains on updown.io
#variables are API KEY and URL (Get from list)
cp domains.txt updowndom.txt
echo "API Key loaded: $UPDOWNAPI"

usecase()
{
echo '
================	
[D]Domains (2 minutes)
[S]Subdomains / Tracklead (1 hour)
Any key to refresh domain input list
================'

read -p '
Make a selection: ' ans0
case $ans0 in

D | d) echo "Registering domain from updowndom.txt file"
	echo "to be used for server status checking"
	checkreg
	bash updown.sh
	return
	;;
S | s) echo "Registering domains from updowndom.txt file"
       echo "to be used for TRACKLEAD status checking"
       checkreg_hour
	bash updown.sh
       return
	;;
*) echo "Refreshing list"
	bash updown.sh
	;;
esac
}

checkreg()
{
#regpart
while IFS= read -r url; do
	curl -X POST -d "url=$url" -d "period=120" https://updown.io/api/checks?api-key=$UPDOWNAPI 
printf "\n"
done < updowndom.txt

#checkpart
figlet "CHECKING"
curl https://updown.io/api/checks?api-key=$UPDOWNAPI > checklog
	sed $'s/{"token"/\\\n/g' < checklog > checklog2
	rm checklog
	mv checklog2 checklog
	cat checklog | grep "Couldn't resolve host name" | cut -f4 -d":" | cut -c3-11 > downdomain

toilet -f pagga "ERRORS FOUND"
cat downdomain
echo -e "\n"
}

checkreg_hour()
{
#regpart
while IFS= read -r url; do
#IF NEED DOMAIN TO BE CHECKED IN AN HOUR USE THIS INSTEAD
	curl -X POST -d "url=$url" -d "period=3600" https://updown.io/api/checks?api-key=$UPDOWNAPI
printf "\n"
done < updowndom.txt

#checkpart
figlet "CHECKING"
curl https://updown.io/api/checks?api-key=$UPDOWNAPI > checklog
	sed $'s/{"token"/\\\n/g' < checklog > checklog2
	rm checklog
	mv checklog2 checklog
	cat checklog | grep "Couldn't resolve host name" | cut -f4 -d":" | cut -c3-11 > downdomain

toilet -f pagga "ERRORS FOUND"
cat downdomain
echo -e "\n"
}

selecta()
{
echo '
================	
[]Reg and check
[R]egister
[C]heck
================'

read -p '
Make a selection: ' ans1
case $ans1 in

#registration
R | r) echo "Registering domain from updowndom.txt file"
	while IFS= read -r url; do
	curl -X POST -d "url=$url" https://updown.io/api/checks?api-key=$UPDOWNAPI \
printf "\n"
done < updowndom.txt
	selecta
	;;

C | c) echo "Checking uptime from registered domains"
#checking
	curl https://updown.io/api/checks?api-key=$UPDOWNAPI > checklog
	sed $'s/{"token"/\\\n/g' < checklog > checklog2
	rm checklog
	mv checklog2 checklog
	cat checklog | grep "Couldn't resolve host name" | cut -f4 -d":" | cut -c3-11 > downdomain

toilet -f pagga "ERRORS FOUND"
cat downdomain
echo -e "\n"

	selecta
	;;
*) echo "Reg and Check selected"
checkreg
	selecta
	;;
esac
}

usecase
