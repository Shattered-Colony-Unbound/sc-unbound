cpp -C -P $1/text/campaign.txt $1/tmp/campaign.txt
perl $1/make-vars.pl $1/text/text.txt $1/tmp/text.hx
perl $1/make-array.pl $1/tmp/campaign.txt $1/tmp/campaign.hx levels
perl $1/make-array.pl $1/text/tutorial.txt $1/tmp/tutorial.hx tutorial
perl $1/make-array.pl $1/text/cities.txt $1/tmp/cities.hx cities
perl $1/make-array.pl $1/text/pedia.txt $1/tmp/pedia.hx pedia
perl $1/make-array.pl $1/text/easter.txt $1/tmp/easter.hx easter

cpp -C -P $1/text/Text.hx $1/src/ui/Text.hx
