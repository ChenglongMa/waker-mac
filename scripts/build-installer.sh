#!/bin/bash

version="1.1"
source_folder="$HOME/Documents/Projects/Others/waker-mac"
project_folder="$source_folder/Waker"
build_folder="$source_folder/build"
archive_folder="$build_folder/archive"
app_folder="$build_folder/app"
dmg_folder="$build_folder/dist"
scripts_folder="$source_folder/scripts"
generate_appcast_script="$scripts_folder/generate_appcast"

app_name="Waker"

# Clean up
echo "> Cleaning up..."
rm -rf "$build_folder"
mkdir -p "$archive_folder" "$app_folder" "$dmg_folder"

# Build the app

echo "> Building the app..."
pushd "$project_folder" || exit

scheme_list=$(xcodebuild -list -json | tr -d "\n")
scheme=$(echo "$scheme_list" | jq -r '.project.schemes[0]')
echo ">> Building scheme: $scheme"

# Build analyze and archive the app

shopt -s nullglob  # Set shell option to produce empty value instead of original string if no match found
shopt -s nocaseglob  # Set shell option to make glob matching case-insensitive

# Find all files ending with .xcworkspace and store the results in an array
workspace_files=( *.xcworkspace )

# Find all files ending with .xcodeproj and store the results in an array
project_files=( *.xcodeproj )

# If at least one .xcworkspace file exists, select the first file for building
if [[ ${#workspace_files[@]} -gt 0 ]]; then
    filetype_parameter="workspace"
    file_to_build="${workspace_files[0]}"
# If no .xcworkspace files exist but at least one .xcodeproj file exists, select the first file for building
elif [[ ${#project_files[@]} -gt 0 ]]; then
    filetype_parameter="project"
    file_to_build="${project_files[0]}"
# If neither type of file exists, output an error message and exit
else
    echo "Error: No .xcworkspace or .xcodeproj files found."
    exit 1
fi

# Remove whitespace characters from the file name
file_to_build=$(echo "$file_to_build" | awk '{$1=$1;print}')

# Install Xcode command line tools
# xcode-select --install

# Use xcodebuild to perform clean, build, and analyze, and use xcpretty for pretty output
# Other options: # -quiet

echo ">> Executing xcodebuild: clean build analyze archive..."
xcodebuild clean build analyze archive \
-scheme "$scheme" \
-destination "platform=macOS,arch=x86_64" \
-"$filetype_parameter" "$file_to_build" \
-archivePath "$archive_folder/$app_name.xcarchive" \
-configuration Release \
| xcpretty #&& exit "${PIPESTATUS[0]}"

build_status=$?

# Check if the build succeeded
if [ $build_status -ne 0 ]; then
    echo "Error: Build failed."
    exit 1
fi

# Export the .app bundle from the .xcarchive directory
echo ">> Exporting the .app bundle..."
xcodebuild -exportArchive \
-archivePath "$archive_folder/$app_name.xcarchive" \
-exportPath "$app_folder" \
-exportOptionsPlist "$scripts_folder/ExportOptions.plist" \
| xcpretty #&& exit "${PIPESTATUS[0]}"

# Create the .dmg file
# FIXME: --filesystem "APFS" not working

create-dmg \
  --volname "$app_name Installer" \
  --window-pos 200 120 \
  --window-size 566 366 \
  --icon-size 100 \
  --icon "$app_name.app" 150 140 \
  --background "$scripts_folder/installer-background.png" \
  --hide-extension "$app_name.app" \
  --app-drop-link 410 140 \
  --codesign "50BAFD31019A2A4BD0D23340E95B1F427033279C" \
  "$dmg_folder/$app_name.dmg" \
  "$app_folder"


# Generate the appcast file
echo "> Generating the appcast file..."

download_url="https://github.com/ChenglongMa/waker-mac/releases/download/$version/"
project_link="https://github.com/ChenglongMa/waker-mac"
release_link="https://github.com/ChenglongMa/waker-mac/releases"

$generate_appcast_script --download-url-prefix "$download_url" \
-o "$source_folder/appcast.xml" \
--link "$project_link" \
--full-release-notes-url "$release_link" \
"$dmg_folder"

echo "Done."
popd || exit