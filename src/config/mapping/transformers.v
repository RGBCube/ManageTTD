module mapping

fn seconds_to_ticks(s string) string {
	return (s.int() * 1000 / 30).str()
}

fn boolean_to_custom_value(values []string) fn (string) string {
	// [false, true]
	return fn [values] (s string) string {
		return values[usize(s.to_lower().bool())]
	}
}
