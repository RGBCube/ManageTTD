module mapping

import config

pub type Mapping = map[string]map[string]Map

pub fn (m Mapping) to_managettd_config() config.ManageTTDConfig {
	mut config_map := map[string]map[string]string{}

	for section, fields in m {
		config_map[section] = map[string]string{}

		for field, map in fields {
			config_map[section][field] = map.transformed_default_value()
		}
	}

	return config.ManageTTDConfig{
		content: config_map
		@type: // TODO
	}
}

[noinit]
pub struct Map {
	equivalent    []string [required]
	documentation string   [required]
	default_value string   [required]
pub:
	transform fn (string) string = fn (s string) string {
		return s
	}
}

pub fn (m Map) section() string {
	return m.equivalent[0]
}

pub fn (m Map) field() string {
	return m.equivalent[1]
}

pub fn (m Map) transformed_default_value() string {
	return m.transform(m.default_value)
}

pub fn (m Map) str() string {
	comment := '; ' + m.documentation.split_into_lines().join('; ')

	field := m.field()
	value := m.transformed_default_value()

	return '${comment}\n${field} = ${value}'
}
