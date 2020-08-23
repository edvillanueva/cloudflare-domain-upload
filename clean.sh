cat unregres | grep "not a registered domain" | cut -f5 -d":" | cut -c2-10 | tee unreg1

cat unregres | grep "Failed to lookup registrar and hosting information of" | cut -c106-115 | tee unreg2

cat unreg1 unreg2 > unregs
rm unreg1 unreg2 
tr -d ' ' < unregs > domains.txt
rm unregs
