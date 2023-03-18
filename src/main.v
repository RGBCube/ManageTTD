module main

import config
import cli
import os

fn new_config_command() cli.Command {
	return cli.Command{
		name: 'new-config'
		description: 'Creates a new ManageTTD configuration file in the current directory.'
		execute: fn (command cli.Command) ! {
			file := command.args[0]

			@type := match file {
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
					return error('Unknown configuration file type, cannot create.
Accepted file types are openttd.toml, private.toml and secrets.toml.')
				}
			}

			if os.exists(file) {
				return error('File ${file} already exists.')
			}

			os.write_file(file, @type.mapping().str())!

			println('Successfully created ${file}.')
		}
		required_args: 1
	}
}

fn generate_command() cli.Command {
	return cli.Command{
		name: 'convert'
		usage: 'convert <from.toml> <to.cfg>'
		description: 'Convert a ManageTTD TOML configuration file to an OpenTTD configuration file.'
		required_args: 2
		execute: fn (command cli.Command) ! {
			from := command.args[0]
			to := command.args[1]

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
			new_config_command(),
			generate_command(),
		]
	}
	command.setup()
	command.parse(os.args)
}
