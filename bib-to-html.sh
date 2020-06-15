#!/bin/bash
# Converts a LaTeX/BibTeX .bib file to an HTML page which lists the books by category.
# Requires the .bib file to have "category" and "description" tags.

bookcount=0
# read entire .bib file line-by-line and extract relevant fields
while IFS= read -r line; do
	# Count books
	if [[ $line == *"@book"* ]]; then
		((bookcount++))
	# Extract titles
	elif [[ $line == *"title ="* ]]; then
		newtitle="$(echo $line | cut -d '"' -f2)"
		titles+="${newtitle}\n"
	# Extract authors (write <empty> if blank)
	elif [[ $line == *"author ="* ]]; then
		newauthor="$(echo $line | cut -d '"' -f2)"
		if [[ $newauthor == '' ]]; then
			newauthor="<empty>"
		fi
		authors+="${newauthor}\n"
	# Extract descriptions (write <empty> if blank)
	elif [[ $line == *"description ="* ]]; then
		newdescription="$(echo $line | cut -d '"' -f2)"
		if [[ $newdescription == '' ]]; then
			newdescription="<empty>"
		fi
		descriptions+="${newdescription}\n"
	# Extract categories (write <empty> if blank)
	elif [[ $line == *"category ="* ]]; then
		newcategory="$(echo $line | cut -d '"' -f2)"
		if [[ $newcategory == '' ]]; then
			newcategory="<empty>"
		fi
		categories+="${newcategory}\n"
	fi
done

# Ensure newline characters are interpreted 
titles=$(echo -e $titles)
authors=$(echo -e $authors)
descriptions=$(echo -e $descriptions)
# Sort categories alphabetically; keep only one of each
sortedcategories=$(echo -e "$categories" | sort | uniq)
categories=$(echo -e $categories)

# Convert newline-delimited strings to arrays
IFS=$'\n'
titles=($titles)
authors=($authors)
descriptions=($descriptions)
categories=($categories)              # Array of every book's category, indexed by book
sortedcategories=($sortedcategories)  # Array of all categories 

# Format HTML and emit to stdout
printf "<!DOCTYPE HTML>"
printf "<html lang='en'>\n"
printf "<head>\n"
printf "  <link rel='stylesheet' type='text/css' href='style.css' />\n"
printf "</head>\n"
printf "<body>\n"
printf "  <h1>My Library:</h1>\n"
printf "  <ul>\n"

# Print each category
for (( i=0; i<${#sortedcategories[@]}; i++ ))
do
	echo "  <h2>${sortedcategories[$i]}</h2>"

	# Within each category, print all books that match that category
	for ((j=0; j<${#titles[@]}; j++ ))
	do
		if [[ ${categories[$j]} == ${sortedcategories[$i]} ]]; then
		        title=${titles[$j]}
			author="${authors[$j]}"
			if [[ $author == '<empty>' ]]; then
				author=''
			else
				author="- $author" # To do: Make '-' a $DELIM so it can be changed
			fi
			description=${descriptions[$j]}
			if [[ $description == '<empty>' ]]; then
				description=''
			fi
			printf "    <li class='book'><em>$title</em> $author</li>\n"
			printf "      <ul style='list-style-type:none;'>\n"
			printf "        <li class='description'>$description</li>\n"
			printf "      </ul>\n"
		fi
	done
done
printf "  </ul>\n"
printf "</body>\n"
printf "</html>\n"
