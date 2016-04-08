#!/usr/bin/env sh

${DRY_RUN:=false}

echo
echo "Updating Symlink Scripts for Ruby Projects"
echo

source ./ruby-projects.sh
source ./update-file.sh

working_copies=(
  "${ruby_projects[@]}"
)

files=(
  "library-symlinks.sh"
)

src_dir='contributor-assets'

for dir in "${working_copies[@]}"; do
  for file_name in "${files[@]}"; do
    update_file $file_name $src_dir $dir
    echo
  done
done
