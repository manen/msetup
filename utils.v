module main

// last_element returns the last element of the path after the last /.
// windows users deserve not to have msetup work i'm just saying
fn last_element(path string) string {
	if path.count('/') == 0 {
		return path
	}
	return path.split('/').last()
}
