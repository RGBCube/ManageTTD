module config

pub const openttd_config_mapping = Mapping({
	'ratelimits': {
		'maximum_initialization_time': Map{
			equivalent: ['network', 'max_init_time']
			documentation: 'The time the client has to initialize the game in seconds.'
			default_value: '5'
			transform: seconds_to_ticks
		}
		'maximum_join_time':           Map{
			equivalent: ['network', 'max_join_time']
			documentation: 'The time the client has to join the server in seconds.'
			default_value: '20'
			transform: seconds_to_ticks
		}
		'maximum_download_time':       Map{
			equivalent: ['network', 'max_download_time']
			documentation: 'The time the client has to download the map in seconds.'
			default_value: '300'
			transform: seconds_to_ticks
		}
		'maximum_password_time':       Map{
			equivalent: ['network', 'max_password_time']
			documentation: 'The time the client has to enter the server password in seconds.'
			default_value: '600'
			transform: seconds_to_ticks
		}
		'maximum_lag_time':            Map{
			equivalent: ['network', 'max_lag_time']
			documentation: 'The time the client can lag behind the server in seconds.'
			default_value: '20'
			transform: seconds_to_ticks
		}
	}
	'server':     {
		'is_public': Map{
			equivalent: ['network', 'server_game_type']
			documentation: 'Whether if the server is public. True means the server can be joined from the server list.'
			default_value: 'true'
			transform: boolean_to_custom_value(['private', 'public'])
		}
	}
	'autoclean':  {
		'enabled': Map{
			equivalent: ['network', 'autoclean_companies']
			documentation: 'Whether if the server should automatically clean up companies.
Other autoclean settings only have effect if this is set to true.'
			default_value: 'false'
		}
	}
})

pub const private_config_mapping = Mapping(map[string]map[string]Map{})

pub const secrets_config_mapping = Mapping(map[string]map[string]Map{})
