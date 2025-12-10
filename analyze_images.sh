#!/bin/bash

# Image usage analysis script
# This script checks which images in static/images/ are referenced in markdown files

echo "🔍 Analyzing image usage in static/images/..."
echo

# Count total images
TOTAL_IMAGES=$(find static/images -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" -o -name "*.svg" \) | wc -l)
echo "📊 Total images found: $TOTAL_IMAGES"

# Create temporary files
TEMP_IMAGES=$(mktemp)
TEMP_USED=$(mktemp)
TEMP_UNUSED=$(mktemp)

# Get all images
find static/images -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" -o -name "*.svg" \) | sort > "$TEMP_IMAGES"

echo "🔍 Searching for image references in content files..."

# Search for image references in all content files
USED_COUNT=0
while IFS= read -r image_path; do
    # Extract just the filename
    filename=$(basename "$image_path")
    
    # Search for references to this image in markdown files
    if grep -r "$filename" content/ >/dev/null 2>&1; then
        echo "$image_path" >> "$TEMP_USED"
        ((USED_COUNT++))
    else
        echo "$image_path" >> "$TEMP_UNUSED"
    fi
done < "$TEMP_IMAGES"

UNUSED_COUNT=$((TOTAL_IMAGES - USED_COUNT))

echo
echo "📈 Results:"
echo "  ✅ Used images: $USED_COUNT"
echo "  ❌ Unused images: $UNUSED_COUNT"
echo

if [ $UNUSED_COUNT -gt 0 ]; then
    echo "🗑️  Unused images (first 20):"
    head -20 "$TEMP_UNUSED"
    
    if [ $UNUSED_COUNT -gt 20 ]; then
        echo "  ... and $((UNUSED_COUNT - 20)) more"
    fi
    
    echo
    echo "💾 Space usage analysis:"
    UNUSED_SIZE=$(cat "$TEMP_UNUSED" | xargs du -ch 2>/dev/null | tail -1 | cut -f1)
    echo "  Unused images total size: $UNUSED_SIZE"
    
    echo
    echo "🤔 Would you like to:"
    echo "  1. Show all unused images"
    echo "  2. Delete unused images"
    echo "  3. Show size breakdown by year"
    echo "  4. Exit"
    echo
    read -p "Enter your choice (1-4): " choice
    
    case $choice in
        1)
            echo "📋 All unused images:"
            cat "$TEMP_UNUSED"
            ;;
        2)
            echo "⚠️  This will permanently delete $UNUSED_COUNT unused images!"
            read -p "Are you sure? (y/N): " confirm
            if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                cat "$TEMP_UNUSED" | xargs rm -f
                echo "✅ Deleted $UNUSED_COUNT unused images"
            else
                echo "❌ Operation cancelled"
            fi
            ;;
        3)
            echo "📊 Size breakdown by year:"
            for year in 2019 2020 2021 2022 2023 2024 2025; do
                if grep -q "$year" "$TEMP_UNUSED"; then
                    year_size=$(grep "$year" "$TEMP_UNUSED" | xargs du -ch 2>/dev/null | tail -1 | cut -f1)
                    year_count=$(grep -c "$year" "$TEMP_UNUSED")
                    echo "  $year: $year_count images, $year_size"
                fi
            done
            ;;
        4)
            echo "👋 Exiting..."
            ;;
        *)
            echo "❌ Invalid choice"
            ;;
    esac
else
    echo "🎉 Great! All images are being used."
fi

# Cleanup
rm -f "$TEMP_IMAGES" "$TEMP_USED" "$TEMP_UNUSED" 