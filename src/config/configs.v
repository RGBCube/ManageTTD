module config

import strings

[noinit]
pub struct OpenTTDConfig {
	content map[string]map[string]string
	@type   ConfigType
}

pub fn (oc OpenTTDConfig) str() string {
	mut config_string := strings.new_builder(12800)

	for section, section_content in oc.content {
		config_string.write_string('[${section}]\n')

		for field, value in section_content {
			config_string.write_string('${field} = ${value}\n')
		}
	}

	return config_string.str()
}

pub struct ManageTTDConfig {
	content map[string]map[string]string
	@type   ConfigType
}

// TODO: validate values.
pub fn (mc ManageTTDConfig) validate() ! {
	mapping := mc.@type.mapping()

	for section, section_content in mc.content {
		if section !in mapping {
			return error('Invalid section: ${section}')
		}

		for field, _ in section_content {
			if field !in mapping[section] {
				return error('Invalid key: ${field}')
			}
		}
	}
}

pub fn (mc ManageTTDConfig) to_openttd_config() !OpenTTDConfig {
	mc.validate()!

	mapping := mc.@type.mapping()

	mut openttd_config := map[string]map[string]string{}

	for section, section_content in mc.content {
		section_mapping := mapping[section]

		for field, value in section_content {
			key_mapping := section_mapping[field]

			openttd_config[key_mapping.section()][key_mapping.field()] = key_mapping.transform(value)
		}
	}

	return OpenTTDConfig{
		content: openttd_config
		@type: mc.@type
	}
}
