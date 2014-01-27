<?php

function send() {
	foreach (array('content', 'name', 'email') as $i) {
		if (!array_key_exists($i, $_POST) || empty($_POST[$i])) {
			return false;
		}

		$_POST[$i] = filter_var($i, FILTER_SANITIZE_EMAIL);
	}

	return mail('connor@peet.io', 'Website Contact', "
		--- VIA PYXL ---
		Name: $_POST[name]
		Email: $_POST[email]
		Content: $_POST[content]
	");
}

echo send() ? 1 : 0;