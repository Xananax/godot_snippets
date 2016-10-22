# Reads a directory and calls functions on results
# those functions should return a result which will be appended to
# the returned array.
# if any function returns the `STOP` symbol, the loop will be interrupted
# (note: functions can be encapsulated by doing: funcref(self, "function_name")
# 
# arguments:
#	string path the path to read
#	func when_dir (optional) function to be called on directories
#	func when_file (optional) function to be called on files
#
# when_dir and when_func are optional, but the function will do nothing
# at all if you pass none of them
#
# returns:
#	an array of whatever the functions returned
#
# when_dir and when_file signature:
#	(object file_data, symbol STOP) => result any

# file_data:
#	path is the complete path to the file, including filename
#	name is the name of the file
#	basename is the basename of the file, without extensions
#	dirname is the containing directory
#	extension is the extension of the file, without the dot, and lowercased
#	type is either "file" or "directory"
#	size is the file size
# `STOP` is a symbol that can be returned to short-circuit the loop
# `result` is anything you want to append to the `results` array.

const STOP = {}
const NO_EXTENSION = ''
const TYPE_FILE = "file"
const TYPE_DIRECTORY = "directory"

func read_dir(path,when_dir=null,when_file=null):
	var dir = Directory.new()
	var results = []
	var stop = false
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while  file_name != "" && !stop:
			if file_name != "." && file_name != "..":
				var file_path
				if path == '/':
					file_path = '/'+file_name
				else:
					file_path = path+"/"+file_name
				var ret = null
				
				if when_dir && dir.current_is_dir():
					ret = when_dir.call_func(parse_dir(file_path,file_name),STOP);
				elif when_file:
					ret = when_file.call_func(parse_file(file_path,file_name),STOP);
				
				if typeof(ret) == TYPE_DICTIONARY && ret == STOP:
					return results
				elif ret != null:
					results.push_back(ret)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.");
	return results
	
# Convenience function to read a file properties
func parse_file(path,name):
	var ext = name.extension().to_lower()
	var basename = name.basename()
	var file = File.new()
	var dirname = path.get_base_dir()
	file.open(path,file.READ)
	var data = {
		"path":path,
		"name":name,
		"basename":basename,
		"dirname":dirname,
		"ext":ext,
		"type":TYPE_FILE,
		"size":file.get_len()
	}
	file.close()
	return data
	
func parse_dir(path,name):
	var basename = name
	var dirname = path.get_base_dir()
	var data = {
		"path":path,
		"name":name,
		"basename":basename,
		"dirname":dirname,
		"ext":NO_EXTENSION,
		"type":TYPE_DIRECTORY,
		"size":0
	}
	return data
	