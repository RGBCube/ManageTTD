module config

pub enum ConfigType {
	openttd
	private
	secrets
	// Other config files are not handled by this tool
	// because they are not useful for dedicated servers.
}

pub fn (ct ConfigType) mapping() Mapping {
	return match ct {
		.openttd { openttd_config_mapping }
		.secrets { secrets_config_mapping }
		.private { private_config_mapping }
	}
}
