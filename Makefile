all:
	[ -L "${HOME}/.aliases" ]      || ln -sfr .aliases      "${HOME}/.aliases"
	[ -L "${HOME}/.bash_profile" ] || ln -sfr .bash_profile "${HOME}/.bash_profile"
	[ -L "${HOME}/.gitconfig" ]    || ln -sfr .gitconfig    "${HOME}/.gitconfig"
	[ -L "${HOME}/.tmux.conf" ]    || ln -sfr .tmux.conf    "${HOME}/.tmux.conf"
	[ -L "${HOME}/.vimrc.after" ]  || ln -sfr .vimrc.after  "${HOME}/.vimrc.after"
	[ -L "${HOME}/.vimrc.before" ] || ln -sfr .vimrc.before "${HOME}/.vimrc.before"
