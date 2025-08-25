#!/bin/bash
# Get version number from pubspec.yaml
VERSION=$(grep 'version:' pubspec.yaml 2>/dev/null | sed 's/version: //')
# Get release date
RELEASE_DATE=$(date +"%d.%m.%Y")
# Create a temporary file
temp_file=$(mktemp)
# Write the new header
echo "# Version $VERSION Notes ($RELEASE_DATE)" > "$temp_file"
echo "" >> "$temp_file"
# Check main branch name
if ! git rev-parse --verify main >/dev/null 2>&1; then
  MAIN_BRANCH="master"
else
  MAIN_BRANCH="main"
fi
# Add "Latest Developments" section
echo "## Latest Developments" >> "$temp_file"
echo "" >> "$temp_file"
# Get merge commits
commits_file=$(mktemp)
git log $MAIN_BRANCH..development --first-parent --merges --pretty=format:"%h|%s|%cn|%cd" > "$commits_file"
# Count total commits
TOTAL_COMMITS=$(wc -l < "$commits_file" | tr -d ' ')
if [ "$TOTAL_COMMITS" -eq 0 ]; then
  echo "Error: No merge commits found!" >> "$temp_file"
  echo "It seems there are no merge commits between development and $MAIN_BRANCH." >> "$temp_file"
  echo "" >> "$temp_file"
else
  echo "This release contains a total of **$TOTAL_COMMITS** merge requests since the last merge." >> "$temp_file"
  echo "" >> "$temp_file"

  while IFS='|' read -r hash msg committer date; do
    branch_name=""
    if [[ "$msg" == "Merge branch"* ]]; then
      branch_name=$(echo "$msg" | grep -o "'[^']*'" | head -1 | sed "s/'//g")
    fi

    if [ -z "$branch_name" ]; then
      continue
    fi

    formatted_date=$(date -d "$date" "+%d.%m.%Y" 2>/dev/null || echo "$date" | cut -d' ' -f1-4)
    committer_name=$(echo "$committer" | sed 's/@//g')
    GITHUB_REPO_URL="https://gitlab.com/your_flutter_project"
    commit_url="${GITHUB_REPO_URL}/commit/${hash}"

    echo "- **${branch_name}** ([${hash}](${commit_url})) - ${committer_name} (${formatted_date})" >> "$temp_file"
  done < "$commits_file"

  echo "" >> "$temp_file"
  echo "## Contributors" >> "$temp_file"
  echo "" >> "$temp_file"

  git log $MAIN_BRANCH..development --format='%cn' | sort | uniq -c | sort -nr | while read -r count name; do
    echo "- **$name**: $count commits" >> "$temp_file"
  done

  echo "" >> "$temp_file"
fi
# Add separator
echo "---" >> "$temp_file"
echo "" >> "$temp_file"
# Append existing release notes, skipping duplicate version entries
if [ -f "release_notes.md" ]; then
  if grep -q "# Version $VERSION Notes" release_notes.md; then
    awk "BEGIN{found=0} /^# Version [0-9]+/ {if(found==0){found=1}else{print;f=1;next}} f==1{print}" release_notes.md >> "$temp_file"
  else
    cat release_notes.md >> "$temp_file"
  fi
fi
# Replace the old file with the new content
mv "$temp_file" release_notes.md
# Clean up
rm -f "$commits_file"
echo -e "\nRelease notes have been saved to release_notes.md."