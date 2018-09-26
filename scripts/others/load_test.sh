for i in {1..10000}; do curl -XGET  "http://139.59.50.63:8080/v1/impression/track/?offer_id=1&aff_id=1" & done
for i in {1..10000}; do curl -XGET  "http://139.59.50.63:8080/v1/click/track/?offer_id=1&aff_id=1" & done
