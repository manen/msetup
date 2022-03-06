module main

import os
import cli
import v.embed_file as ef
import time

const (
	author = 'manen'
)

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

	test_dir := if os.exists('./.dont_msetup_here') { './test/' } else { './' }

	editorconfig := ctx.process_embed($embed_file('./data/.editorconfig'))
	license := ctx.process_embed($embed_file('./data/LICENSE.txt'))
	readme := ctx.process_embed($embed_file('./data/README.md'))

	editorconfig.write(test_dir) ?
	license.write(test_dir) ?
	readme.write(test_dir) ?
}
