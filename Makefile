all:
	[ -L "${HOME}/.aliases" ]      || ln -sf .aliases      "${HOME}/.aliases"
	[ -L "${HOME}/.bash_profile" ] || ln -sf .bash_profile "${HOME}/.bash_profile"
	[ -L "${HOME}/.gitconfig" ]    || ln -sf .gitconfig    "${HOME}/.gitconfig"
	[ -L "${HOME}/.tmux.conf" ]    || ln -sf .tmux.conf    "${HOME}/.tmux.conf"
	[ -L "${HOME}/.vimrc.after" ]  || ln -sf .vimrc.after  "${HOME}/.vimrc.after"
	[ -L "${HOME}/.vimrc.before" ] || ln -sf .vimrc.before "${HOME}/.vimrc.before"
