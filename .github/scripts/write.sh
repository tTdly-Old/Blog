TITLE=$(echo $1 | jq .event.issue.title)
NUMBER=$(echo $1 | jq .event.issue.number)
BODY=$(echo $1 | jq .event.issue.body)
BODY=$(echo ${BODY:1:-1})
TIME=$(echo $1 | jq .event.issue.created_at)
LABLES=$(echo $RESULT | jq '.event.issue.labels | map(.name)')
HEADYML="---\ntitle: $TITLE\ndate: $TIME\ntags: $LABLES---\n"

if [ ! -d "posts" ];then
    mkdir posts
fi

echo -e $HEADYML > $NUMBER.1
echo -e $BODY >> $NUMBER.1

while read line
do
  echo -e $line >> posts/$NUMBER.md
done < $NUMBER.1
cat posts/$NUMBER.md > index.md

rm $NUMBER.1

cat posts/$NUMBER.md > index.md