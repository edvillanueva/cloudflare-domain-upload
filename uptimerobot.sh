#This script will be used for uploading/deleting domains thru API
read -p "Enter API key for uptimerobot: " api_key
echo "API key assigned as [$api_key]"
echo "Getting account status"
#get status of account [optional to check right api is loaded]
curl -X POST -H "Cache-Control: no-cache" -H "Content-Type: application/x-www-form-urlencoded" -d "api_key=$api_key&format=json" "https://api.uptimerobot.com/v2/getAccountDetails" | jq

#get contact alert ID
ContactId=$(curl -X POST -H "Cache-Control: no-cache" -H "Content-Type: application/x-www-form-urlencoded" -d 'api_key='"$api_key"'&format=json' "https://api.uptimerobot.com/v2/getAlertContacts" | jq -r '.alert_contacts[] | select(.friendly_name == "The Boss") | .id')
echo "Alert contact ID pulled:" $ContactId
#select case if keyword or HTTPS
read -p "Press 1 for HTTPS, 2 for Keyword check: " ans
case $ans in
    1) echo "Selected HTTPS check"
        sleep 1
        #for loop for loading bulk checks
            for UptimeCheckDom in $(cat uptimechecks.txt); 
            do
                #HTTPS check
                curl -X POST -H "Cache-Control: no-cache" -H "Content-Type: application/x-www-form-urlencoded" -d 'api_key='"$api_key"'&format=json&type=1&url='"$UptimeCheckDom"'&friendly_name='"$UptimeCheckDom"'&alert_contacts='"$ContactId"'_5_0'' "https://api.uptimerobot.com/v2/newMonitor"' | jq
                sleep 2
            done
        ;;
    2) echo "Selected Keyword [Forbidden keyword check]"
        sleep 1
            for UptimeCheckDom in $(cat uptimechecks.txt);
                do
                #Keyword [Forbidden] check
                curl -X POST -H "Cache-Control: no-cache" -H "Content-Type: application/x-www-form-urlencoded" -d 'api_key='"$api_key"'&format=json&type=2&url='"$UptimeCheckDom"'&friendly_name='"$UptimeCheckDom"'&keyword_type=1&keyword_value=Forbidden&alert_contacts='"$ContactID"'_5_0' "https://api.uptimerobot.com/v2/newMonitor" | jq
                sleep 2
                done
        ;;
    *) echo "Invalid input - closing script"
esac

