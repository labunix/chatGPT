#!/bin/bash
DEBUG=#

myCheck() {
  if [ $(wc -c < ${keyfile}) -ne 52 ];then
    echo "https://platform.openai.com/account/api-keys"
    echo "API keys"
    echo "Create new secret key"
    echo "and write file to [${keyfile}]"
    exit 2
  else
    chmod 400 ${keyfile}
  fi

  if [ "$DEBUG" != "#" ];then
    echo "Your API Key is $(cat ${keyfile})"
    echo "Your Querion is ${myContent}"
    exit 0
  fi
}

myContent="$*"

if [ $# -lt 1 ];then
  echo "Usage $0 [message]"
  exit 2
fi

keyfile=~/.openai-api-key

myCheck

myChatGPT() {
  curl https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $(cat ${keyfile})" \
    -d @- <<EOS
    {
      "model": "gpt-3.5-turbo",
      "messages": [
         {"role": "user", "content": "I will ask you a question in Japanese, so please answer in Japanese."},
         {"role": "user", "content": "${myContent}"}
      ]
    }
EOS
}

myChatGPT | jq -r '.["choices"][0]["message"]["content"]'
