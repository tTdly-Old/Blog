# $1 title $2 body $3 labels $4 number $5 time
if [ ! -d "posts" ];then
    mkdir posts
fi

LABLES=(echo $3 | jq '. | map(.name)')
HEADYML="---\ntitle: $1\ndate: $5\n---"
echo -e $HEADYML > $4.1
echo -e $2 >> $4.1
while read line
do
  echo -e $line >> posts/$4.md
done < $4.1

rm $NUMBER.1
