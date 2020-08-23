curl -X PATCH "https://api.cloudflare.com/client/v4/zones/e2799f7e1b71f3307a0e66a08981bf82/settings/ssl" \
     -H "X-Auth-Email: icnos@mailnesia.com" \
     -H "X-Auth-Key: f555e06f2a0fdb7d4d8c53ad573fbc58628a9" \
     -H "Content-Type: application/json" \
     --data '{"value":"off"}'
