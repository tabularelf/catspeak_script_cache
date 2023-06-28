function catspeak_load_script(_file) {
	// Get name of file
	var _filename = filename_name(_file);
	var _ext = filename_ext(_filename);
	_filename = string_delete(_filename, string_pos(_ext, _filename), string_length(_ext));
	var _cacheFilename = ".cache/" + _filename + ".catc";
	
	// Store cache value
	var _cacheExists = file_exists(_cacheFilename);
	
	var _asg = undefined;
	
	if (_cacheExists) {
		var _buff = buffer_load(_cacheFilename);
		var _hash = buffer_read(_buff, buffer_string);
		
		// I wonder if this is cross-platform safe? Needs verifying...
		var _ogHash = sha1_file(_file);
		
		if (_hash != _ogHash) {
			show_debug_message("Mismatch hash from " + _cacheFilename + "... Clearing cache.");
			file_delete(_cacheFilename);
			_cacheExists = false;
		} else {
			var _buffMain = buffer_create(buffer_get_size(_buff) - buffer_tell(_buff), buffer_grow, 1);
			buffer_copy(_buff, buffer_tell(_buff), buffer_get_size(_buff), _buffMain, 0);
			_buffMain = decompress_buffer_data(_buffMain);
			_asg = SnapBufferReadBinary(_buffMain, 0);
			buffer_delete(_buffMain);
			buffer_delete(_buff);
			
			return _asg;
		}
	}
	
	if (!_cacheExists) {
		var _buff = buffer_load(_file);
		var _hash = buffer_sha1(_buff, 0, buffer_get_size(_buff));
		var _str = buffer_read(_buff, buffer_text);
		buffer_delete(_buff);
		_asg = Catspeak.parseString(_str);
		var _buff = buffer_create(1, buffer_grow, 1);
		SnapBufferWriteBinary(_buff, _asg);
		
		// Scale down size
		buffer_resize(_buff, buffer_tell(_buff));
		_buff = compress_buffer_data(_buff);
		
		var _buffMain = buffer_create(1, buffer_grow, 1);
		buffer_write(_buffMain, buffer_string, _hash);
		buffer_copy(_buff, buffer_tell(_buff), buffer_get_size(_buff), _buffMain, buffer_tell(_buffMain));
		buffer_save(_buffMain, _cacheFilename);
		buffer_delete(_buffMain);
		buffer_delete(_buff);
	}
	
	return _asg;
}