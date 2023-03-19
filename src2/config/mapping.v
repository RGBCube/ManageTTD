module config

pub type Mapping = map[string]map[string]Map

// TODO: &Mapping
pub fn (mpng Mapping) unmap(mapped map[string]map[string]string) !map[string]map[string]string {
	mut unmapped := map[string]map[string]string{}

	for mapped_section, mapped_fields in mapped {
		if mapped_section !in mpng {
			return error('Unknown section: ${mapped_section}')
		}

		for mapped_field, mapped_value in mapped_fields {
			if mapped_field !in mpng[mapped_section] {
				return error('Unknown field: ${mapped_section}.${mapped_field}')
			}

			mapped_field_mapping := mpng[mapped_section][mapped_field]

			unmapped[mapped_field_mapping.section()][mapped_field_mapping.field()] = mapped_field_mapping.transform(mapped_value)
		}
	}

	return unmapped
}

pub enum ValueType {
	string
	integer
	boolean
}

// Maps one ManageTTD -> OpenTTD config field.
[noinit]
pub struct Map {
	equivalent  [2]string           [required]
	transformer ?fn (string) string
pub:
	@type         ValueType = .string
	documentation string    [required]
}

[inline]
pub fn (m &Map) section() string {
	return m.equivalent[0]
}

[inline]
pub fn (m &Map) field() string {
	return m.equivalent[1]
}

pub fn (m &Map) transform(s string) string {
	return if transform_fn := m.transformer {
		transform_fn(s)
	} else {
		s
	}
}
