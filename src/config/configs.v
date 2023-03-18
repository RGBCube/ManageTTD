module config

import strings
import toml

fn nested_string_map_to_toml(m map[string]map[string]string) string {
	mut toml_string := strings.new_builder(12800)

	for section, fields in m {
		toml_string.writeln('[${section}]')

		for field, value in fields {
			toml_string.writeln('${field} = ${value}')
		}

		toml_string.write_rune(`\n`)
	}

	return toml_string.str()
}

[noinit]
pub struct OpenTTDConfig {
	content map[string]map[string]string
	@type   ConfigType
}

pub fn (oc OpenTTDConfig) str() string {
	return nested_string_map_to_toml(oc.content)
}

pub fn managettd_config_from_file(path string, @type ConfigType) !ManageTTDConfig {
	config_toml := toml.parse_file(path)!

	return ManageTTDConfig{
		content: config_toml.reflect[map[string]map[string]string]()
		@type: @type
	}
}

pub struct ManageTTDConfig {
	content map[string]map[string]string
	@type   ConfigType
}

pub fn (mc ManageTTDConfig) str() string {
	return nested_string_map_to_toml(mc.content)
}

// TODO: validate values.
pub fn (mc ManageTTDConfig) validate() ! {
	mapping := mc.@type.mapping()

	for section, fields in mc.content {
		if section !in mapping {
			return error('Invalid section: ${section}')
		}

		for field, _ in fields {
			if field !in mapping[section] {
				return error('Invalid key: ${field}')
			}
		}
	}
}

pub fn (mc ManageTTDConfig) to_openttd_config() !OpenTTDConfig {
	mc.validate()!

	mapping := mc.@type.mapping()

	mut config := map[string]map[string]string{}

	for section, fields in mc.content {
		section_mapping := mapping[section].clone()

		for field, value in fields {
			key_mapping := section_mapping[field]

			config[key_mapping.section()][key_mapping.field()] = key_mapping.transform(value)
		}
	}

	return OpenTTDConfig{
		content: config
		@type: mc.@type
	}
}
