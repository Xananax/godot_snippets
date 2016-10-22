LINKS="\n"
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
		echo -e "\n\`\`\`gdscript" >> "$readme"
		cat $script >> "$readme"
		echo -e "\n\`\`\`" >> "$readme"
		echo "## Example of Usage" >> "$readme"
		echo -e "\n\`\`\`gdscript" >> "$readme"
		cat $usage_script >> "$readme"
		echo -e "\n\`\`\`" >> "$readme"
		LINKS="$LINKS\n - [$base](./$base)"
	fi
done

EXREADME="../examples/README.md"

rm -rf $EXREADME
touch $EXREADME
cat ../examples/contribute.md > $EXREADME
echo -e "\n## List of available snippets" >> $EXREADME
echo -e $LINKS >> $EXREADME