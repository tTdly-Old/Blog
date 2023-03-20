# init
Tilte=$(echo $1 | jq .event.issue.title)
Number=$(echo $1 | jq .event.issue.number)
Body=$(echo $1 | jq .event.issue.body)
Time=$(echo $1 | jq .event.issue.created_at)
# labels数组
labels=($(echo $1 | jq -r '.event.issue.labels[].name'))
length=${#labels[@]}
# 拼接labels
Lable="tags:[\""${labels[0]}"\""

for(( i=1;i<$length;i++)) do
Lable=$Lable","
Lable=${Lable}"\""${labels[i]}"\""
done

Lable=$Lable"]\n"
if [ "$length" -eq "0" ];then
Label=""
fi

HEADYML="---\ntitle: $Tilte\ndate: $Time\n$Label---\n"
# 处理Body
Body=$(echo ${Body:1:-1})
if [ ! -d "posts" ];then
    mkdir posts
fi

echo -e $HEADYML > $Number.1
echo -e $Body >> $Number.1

while read line
do
  echo -e $line >> posts/$Number.md
done < $Number.1
cat posts/$Number.md > index.md

rm $Number.1

cat posts/$Number.md > index.md