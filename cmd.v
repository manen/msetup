module main

import os
import cli

const (
	symlink_path = '/usr/bin/msetup'
)

fn main() {
	mut app := cli.Command{
		name: 'msetup'
		description: "manen's fairly useless quick setup utility"
		execute: run
		commands: [
			// cli.Command{
			// 	name: 'sub'
			// 	execute: fn (cmd cli.Command) ? {
			// 		println('Hello subscribe and like')
			// 		return
			// 	}
			// },
			cli.Command{
				name: 'symlink'
				description: 'Symlink the executable into \$PATH (hopefully)'
				execute: symlink
			},
			cli.Command{
				name: 'unlink'
				description: 'Deletes the msetup symlink from \$PATH'
				execute: unlink
			},
		]
	}

	app.setup()
	app.parse(os.args)
}

fn symlink(cmd cli.Command) ? {
	os.symlink(os.executable(), symlink_path) ?
}

fn unlink(cmd cli.Command) ? {
	os.rm(symlink_path) ?
}
