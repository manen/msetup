module main

import os
import cli
import v.embed_file as ef
import time

const (
	author = 'manen'
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
		]
	}

	app.setup()
	app.parse(os.args)
}

struct Context {
	name   string
	desc   string
	year   string
	author string
}

fn assume_context() Context {
	return Context{os.getwd(), os.getwd(), time.now().year.str(), author}
}

struct Templated {
	path string
	data string
}

fn (ctx Context) process_embed(raw ef.EmbedFileData) Templated {
	return Templated{raw.path, ctx.process_content(raw.to_string())}
}

fn (ctx Context) process_content(raw string) string {
	// things to fill:
	// %name
	// %desc
	// %year
	// %author

	return raw.replace('%name', ctx.name).replace('%desc', ctx.desc).replace('%year',
		ctx.year).replace('%author', ctx.author)
}

fn (tmpl Templated) write(dir string) ? {
	full_path := os.join_path(dir, tmpl.path)

	os.mkdir_all(os.dir(full_path)) ?
	os.write_file(full_path, tmpl.data) ?
}

fn run(cmd cli.Command) ? {
	// the point of this utility is to generate a 'minimum viable project'
	// so set up a license, editorconfig, even maybe readme, etc

	ctx := assume_context()

	test_dir := './test/'

	editorconfig := ctx.process_embed($embed_file('./data/.editorconfig'))
	license := ctx.process_embed($embed_file('./data/LICENSE.txt'))
	readme := ctx.process_embed($embed_file('./data/README.md'))

	editorconfig.write(test_dir) ?
	license.write(test_dir) ?
	readme.write(test_dir) ?
}
