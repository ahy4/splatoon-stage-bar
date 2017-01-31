#!/bin/zsh

session_cookie="_wag_session="`tr -d "\n" < ~/homestead/splbar3/.cookie`
ua_option="'User-Agent: splatoon-stage-bar/0.1 (+https://github.com/ahyahya/splatoon-stage-bar)'"

member_json=`curl -s --cookie ${session_cookie} https://splatoon.nintendo.net/friend_list/index.json | jq .`
current_stage=`curl -s -H ${ua_option} https://splapi.fetus.jp/gachi/now | jq '.'`
next_stages=`curl -s -H ${ua_option} https://splapi.fetus.jp/gachi/next_all | jq '.'`
members=`echo $member_json | jq -r '.[].mii_name'`

function print_stage () {
  echo `echo $1 | jq -r '.start' | sed -e 's/^[^T]*T\([^:]*\):.*$/\1/g'`:00~$'\t'`echo $1 | jq -r '.rule'`:$'　\t'`echo $1 | jq -r '.maps[]' | tr '\n' '　' | sed -e 's/.$//'`" | color=yellow href=https://splatoon.nintendo.net/schedule"
}

cat << EOS
くコ:彡
---
ステージ & ルール | size=18
EOS

print_stage "`echo $current_stage | jq -rc '.result[]'`"
print_stage "`echo $next_stages | jq -rc '.result[0]'`"
print_stage "`echo $next_stages | jq -rc '.result[1]'`"

cat << EOS
---
フレンド | size=18
EOS
if [[ $members = '' ]]; then
  echo '0人'
else
  echo $members | sed -e 's/ /\\\\n/g'
fi
