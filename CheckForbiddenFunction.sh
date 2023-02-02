#!/bin/bash
#graiolo TheChicken

project="src/$1"
files=("${@:2}")

if [ -f "$project" ]; then
  comm -23 <(sort src/functionlist) <(sort "$project") > tmp_functionlist
else
  cat src/functionlist > tmp_functionlist
fi

while read -r word; do
  keywords+=( "$word" )
done < "tmp_functionlist"

for file in "${files[@]}"; do
  printf "\033[32mVerifying\033[0m $file"
   error_found=false
   p_error=false
  for word in "${keywords[@]}"; do
    if grep -qw "$word" "$file"; then
	 error_found=true
    if ! $p_error; then
      printf "\033[31m Error!\033[0m\n"
    fi
	 p_error=true
	 lines=$(grep -nw "$word" "$file" | awk -F: '{print $1}')
	 for line in $lines; do
       printf "\033[31mError!\033[0m: \033[36m$word\033[0m \033[33mfound at line\033[0m: $line\n"
      done
    fi
  done
  if ! $error_found; then
    printf "\033[32m OK\033[0m\n"
  fi
done
rm -f tmp_functionlist
#