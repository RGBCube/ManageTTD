module main

import config
import cli
import os

fn generate_command() cli.Command {
	return cli.Command{
		name: 'convert'
		usage: 'convert <from.toml> <to.cfg>'
		description: 'Convert a ManageTTD TOML configuration file to an OpenTTD configuration file.'
		required_args: 2
		execute: fn (cmd cli.Command) ! {
			from := cmd.args[0]
			to := cmd.args[1]

			@type := match from {
				'openttd.toml' {
					config.ConfigType.openttd
				}
				'private.toml' {
					config.ConfigType.private
				}
				'secrets.toml' {
					config.ConfigType.secrets
				}
				else {
					return error('Unknown configuration file type, cannot convert.
Accepted file types are openttd.toml, private.toml and secrets.toml.')
				}
			}

			managettd_config := config.managettd_config_from_file(from, @type)!
			openttd_config_string := managettd_config.to_openttd_config()!.str()

			os.write_file(to, openttd_config_string)!
			println('Successfully converted ${from} to ${to}.')
		}
	}
}

fn main() {
	mut command := cli.Command{
		name: 'managettd'
		description: 'OpenTTD server management software.'
		version: '0.0.1'
		commands: [
			generate_command(),
		]
	}
	command.setup()
	command.parse(os.args)
}
