// These are optional, meant to ease compressing/decompressing buffers 
// And returning them all within a single call.
// If you don't want to include these, please strip these out from catspeak_load_script

function compress_buffer_data(_buff, _offset = 0, _size = buffer_get_size(_buff)) {
	var _cbuff = buffer_compress(_buff, _offset, _size);
	buffer_delete(_buff);
	return _cbuff;
}

function decompress_buffer_data(_buff) {
	var _dbuff = buffer_decompress(_buff);
	if (_dbuff == -1) {
		show_error("Invalid buffer decompression! Buffer was not compressed?", true);
	}
	buffer_delete(_buff);
	return _dbuff;
}