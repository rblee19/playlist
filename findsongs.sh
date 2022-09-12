set +x
notFoundCount=0
totalFoundCount=0

rm list_found.csv list_not_found.csv list_multiple.csv

while IFS=, read -r song artist album; do     
  echo "-------------------------------------"
  echo "Song: $song, artist: $artist, album: $album"
  
  song=$(echo $song | sed 's/ (.*)//' | sed 's/ \[.*\]//' | sed 's/"//' | sed 's/ [/]\(.\{5\}\).*/ _\1/')
  echo "Cleaned: $song"
   
  # remove dots with underscore in artist text
  artist=$(echo $artist | sed 's/[.]/_/g')
  
  if [ -d "/Users/robbie/Desktop/Music/$artist" ]
  then
     echo "find song in artist folder:"
     find "/Users/robbie/Desktop/Music/$artist" -type f -iname "*$song*"
     foundInArtistFolder=$(find "/Users/robbie/Desktop/Music/$artist" -type f -iname "*$song*" | wc -l | tr -d '[:space:]')
     echo "foundInArtistFolder: [$foundInArtistFolder]"

     if [[ "$foundInArtistFolder" == "1" ]]
     then
        echo "$song,$artist,$album" >> list_found.csv
        echo "Found song in artist folder"
        totalFoundCount=$((totalFoundCount+1))
     elif [[ "$foundInArtistFolder" -gt "1" ]]
     then
        echo "WARNING: Found multiple matches"
        echo "$song,$artist,$album" >> list_multiple.csv
     else
        # TODO search in artist folder by removing everything in parenthesis 

        echo "Did not find song in artist folder"
        echo "++++++++"   
        echo "find by song everywhere:"  
        find /Users/robbie/Desktop/Music -type f -iname "*$song*"
   
        foundCount=$(find /Users/robbie/Desktop/Music -type f -iname "*$song*" | wc -l | tr -d '[:space:]')
        echo "Found: $foundCount" 

        if [[ "$foundCount" == "1" ]]
        then
          echo "$song,$artist,$album" >> list_found.csv
          echo "Found song everywhere"
          totalFoundCount=$((totalFoundCount+1))
        elif [[ "$foundCount" -gt "1" ]]
        then
          echo "$song,$artist,$album" >> list_multiple.csv
          echo "WARNING: Found multiple matches everywhere"
        else 
          echo "$song,$artist,$album" >> list_not_found.csv
          echo "WARNING: song not matched"
          notFoundCount=$((notFoundCount+1))
        fi
     fi

  else
     echo "++++++++++++++++++++++++"   
     echo "find by song everywhere: artist folder not found"  
     find /Users/robbie/Desktop/Music -type f -iname "*$song*"
   
     foundCount=$(find /Users/robbie/Desktop/Music -type f -iname "*$song*" | wc -l | tr -d '[:space:]')
     echo "Found: $foundCount"

     if [[ "$foundCount" == "1" ]]
     then
       echo "$song,$artist,$album" >> list_found.csv
       echo "Found song everywhere"
       totalFoundCount=$((totalFoundCount+1))
     elif [[ "$foundCount" -gt "1" ]]
     then
       echo "$song,$artist,$album" >> list_multiple.csv
       echo "WARNING: Found multiple matches everywhere"
     else 
       echo "$song,$artist,$album" >> list_not_found.csv
       echo "WARNING: song not matched"
       notFoundCount=$((notFoundCount+1))
     fi
  fi
done < LikesPlaylist.csv
#done < LikesPlaylistNotFoundNoParenthesis.csv
#done < LikesPlaylistNotFoundNoExplicit.csv
#done < LikesPlaylistNotFound440.csv
  

echo "*******************************************"
echo "Not found count: $notFoundCount"
echo "Found count: $totalFoundCount"
wc -l list_*.csv

# sed 's/ ([^)]*),/,/' LikesPlaylistNotFound.csv > LikesPlaylistNotFoundNoParenthesis.csv
# sed 's/ ([^)]*),/,/' LikesPlaylistNotFoundNoParenthesis.csv > LikesPlaylistNotFoundNoParenthesis2.csv

 
# sed  's/\[Explicit\]//'  LikesPlaylistNotFoundNoParenthesis2.csv > LikesPlaylistNotFoundNoExplicit.csv 
