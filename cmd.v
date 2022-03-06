module main

import os
import cli

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
		]
	}

	app.setup()
	app.parse(os.args)
}
