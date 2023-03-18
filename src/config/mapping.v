module config

import strings

pub type Mapping = map[string]map[string]Map

pub fn (m Mapping) str() string {
	mut mapping_string := strings.new_builder(12800)

	for section, fields in m {
		mapping_string.writeln('[${section}]')

		for field, field_value in fields {
			mapping_string.writeln('${field} = ${field_value.transformed_default_value()}}')
		}

		mapping_string.write_rune(`\n`)
	}

	return mapping_string.str()
}

pub fn (m Mapping) to_openttd_config(@type ConfigType) OpenTTDConfig {
	return m.to_managettd_config(@type).to_openttd_config() or { panic('unreachable') }
}

pub fn (m Mapping) to_managettd_config(@type ConfigType) ManageTTDConfig {
	mut config_map := map[string]map[string]string{}

	for section, fields in m {
		config_map[section] = map[string]string{}

		for field, field_value in fields {
			config_map[section][field] = field_value.transformed_default_value()
		}
	}

	return ManageTTDConfig{
		content: config_map
		@type: @type
	}
}

[noinit]
pub struct Map {
	equivalent    []string           [required]
	documentation string             [required]
	default_value string             [required]
	transform     fn (string) string = fn (s string) string {
		return s
	}
}

pub fn (m Map) str() string {
	comment := '; ' + m.documentation.split_into_lines().join('; ')

	field := m.field()
	value := m.transformed_default_value()

	return '${comment}\n${field} = ${value}'
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
