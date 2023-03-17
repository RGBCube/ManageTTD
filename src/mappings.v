module main

type MappingValue = Comment | Field

[params]
struct Field {
	// The name of the field in openttd.cfg file.
	// This is the thing OpenTTD seees.
	name string [required]
	// The docs for the field.
	docs string [required]
	// The value of the field.
	value string [required]
	// Transforms the value.
	transformer fn (string) string = fn (s string) string {
		return s
	}
}

type Comment = string

fn field(f Field) MappingValue {
	return f
}

fn comment(c Comment) MappingValue {
	return c
}

fn seconds_to_ticks(s string) string {
	return (s.int() * 1000 / 30).str()
}

const mappings = {
	'time_limits.maximum_initialization_time': field(
		name: 'network.max_init_time'
		docs: 'The time the client has to initialize the game in seconds.'
		value: '5'
		transformer: seconds_to_ticks
	)
	'time_limits.maximum_join_time':           field(
		name: 'network.max_join_time'
		docs: 'The time the client has to join the server in seconds.'
		value: '20'
		transformer: seconds_to_ticks
	)
	'time_limits.maximum_download_time':       field(
		name: 'network.max_download_time'
		docs: 'The time the client has to download the map in seconds.'
		value: '300'
		transformer: seconds_to_ticks
	)
	'time_limits.maximum_password_time':       field(
		name: 'network.max_password_time'
		docs: 'The time the client has to enter the server password in seconds.'
		value: '600'
		transformer: seconds_to_ticks
	)
	'time_limits.maximum_lag_time':            field(
		name: 'network.max_lag_time'
		docs: 'The time the client can lag behind the server in seconds.'
		value: '20'
		transformer: seconds_to_ticks
	)
}
