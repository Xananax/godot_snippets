for dir in ../examples/*/; do
	no_backslash=${dir%*/}
    	base=${no_backslash##*/}
	script="$no_backslash/$base.gd"
	usage_script="$no_backslash/usage.gd"
	readme="$no_backslash/readme.md"
	if [ "$base" != "_template" ]; then
		echo $readme
	fi
done