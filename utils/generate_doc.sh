for dir in ../examples/*/; do
	no_backslash=${dir%*/}
    	base=${no_backslash##*/}
	script="$no_backslash/$base.gd"
	usage_script="$no_backslash/usage.gd"
	readme="$no_backslash/readme.md"
	if [ "$base" != "_template" ]; then
		rm -rf "$readme"
		touch "$readme"
		echo "# $base" > "$readme"
		echo "## Example Implementation" >> "$readme"
		echo "\`\`\`gdscript" >> "$readme"
		cat $script >> "$readme"
		echo "\`\`\`" >> "$readme"
		echo "## Example of Usage" >> "$readme"
		echo "\`\`\`gdscript" >> "$readme"
		cat $usage_script >> "$readme"
		echo "\`\`\`" >> "$readme"
	fi
done