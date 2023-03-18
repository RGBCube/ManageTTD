module config

import config.mapping

pub enum ConfigType {
	openttd
	private
	secrets
	// Other config files are not handled by this tool
	//  because they are not useful for dedicated servers.
}

fn (ct ConfigType) mapping() mapping.Mapping {
	return match ct {
		.openttd { mapping.openttd_config }
		.private { mapping.private_config }
		.secrets { mapping.secrets_config }
	}
}
