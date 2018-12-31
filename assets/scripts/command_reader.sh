while IFS="" read -r p || [ -n "$p" ]
do
  #echo "$(az $p -h)\n"
  printf 'az %s\n' "$p"
  echo "$(az $p -h)\n" >> everything.txt
done < all_groups.txt