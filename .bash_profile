[ -f "${HOME}/.my_secrets" ] && . "${HOME}/.my_secrets"


export ACTIVE_RUBY="${ACTIVE_RUBY}"
export ACTIVE_RUBY_PATH="${ACTIVE_RUBY_PATH}"

export LC_ALL=en_US.UTF-8

export PROXY_HOST=
export PROXY_PORT=
export XDG_CONFIG_HOME=${HOME}
export VPN_PIDS=

export PATH="/usr/local/sbin:${PATH}"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"

export PATH="${HOME}/bin:${PATH}"



# helpful functions

activate_ruby()
{
  [ -f ".ruby-version" ] && ACTIVE_RUBY=$(head -1 .ruby-version)

  ACTIVE_RUBY="${ACTIVE_RUBY:-2.6.6}"

  [ -d "${ACTIVE_RUBY}" ] && ACTIVE_RUBY_PATH="${ACTIVE_RUBY}" || ACTIVE_RUBY_PATH="${HOME}/.rubies/${ACTIVE_RUBY}"

  export LDFLAGS="-L${ACTIVE_RUBY_PATH}/lib"
  export CPPFLAGS="-I${ACTIVE_RUBY_PATH}/include"

  export PKG_CONFIG_PATH="${ACTIVE_RUBY_PATH}/lib/pkgconfig"

  path_contains "${ACTIVE_RUBY_PATH}/bin" || export PATH="${ACTIVE_RUBY_PATH}/bin:${PATH}"
}


deactivate_ruby()
{
  [ -z "${ACTIVE_RUBY_PATH}" ] && return 0

  remove_from_path "${ACTIVE_RUBY_PATH}"

  export ACTIVE_RUBY_PATH=
  export ACTIVE_RUBY=
}


install_janus()
{
  local required_packages=

  command -v git   >>/dev/null || required_packages="${required_packages} git"
  command -v ruby  >>/dev/null || required_packages="${required_packages} ruby"
  command -v ctags >>/dev/null || required_packages="${required_packages} ctags"
  command -v ack   >>/dev/null || required_packages="${required_packages} ack"
  command -v rake  >>/dev/null || required_packages="${required_packages} rake"

  [ -d ~/.vim ] || git clone https://github.com/codylane/janus.git ~/.vim

  if [ -n "${required_packages}" ]; then
    echo "Please make sure that you have the following packages installed [${required_packages}]"
    return 1
  fi

  rm -f ~/.vim/bootstrap.sh
  rm -f ~/.vim/Rakefile
  rm -f ~/.vim/janus/bootstrap.sh

  cd ~/.vim/janus >>/dev/null

  # install
  rake

  # update
  rake dev:update_submodules

  rm -rf janus/vim/tools/vimcss-color
  rm -rf janus/vim/tools/snipmate

  sed -i.bak -e '/css-color/d' janus/submodules.yaml
  rm -f .bak

  mkdir -p  ~/.janus/

  cd ~/.janus

  [ -d ansible-vim ]        || git clone https://github.com/pearofducks/ansible-vim.git
  [ -d tabular ]            || git clone https://github.com/godlygeek/tabular.git
  [ -d tcomment_vim ]       || git clone https://github.com/tomtom/tcomment_vim.git
  [ -d vim-flake8 ]         || git clone https://github.com/nvie/vim-flake8.git
  [ -d vim-tmux-navigator ] || git clone https://github.com/christoomey/vim-tmux-navigator.git
  [ -d vim-airline ]        || git clone https://github.com/vim-airline/vim-airline.git
  [ -d supertab    ]        || git clone https://github.com/ervandew/supertab.git

  mkdir -p ~/nvim
  mkdir -p ~/.config/nvim

  ln -sf ~/.vimrc ~/nvim/init.vim
  ln -sf ~/.vimrc ~/.config/nvim/init.vim

  cd ${HOME}

  [ -f .vimrc.after ]  || curl -kLO https://raw.githubusercontent.com/codylane/dotfiles/master/.vimrc.after
  [ -f .vimrc.before ] || curl -kLO https://raw.githubusercontent.com/codylane/dotfiles/master/.vimrc.before
  [ -f .bash_prompt ]  || curl -kLO https://raw.githubusercontent.com/codylane/dotfiles/master/.bash_prompt
  [ -f .aliases ]      || curl -kLO https://raw.githubusercontent.com/codylane/dotfiles/master/.aliases

  command -v pip2 >>/dev/null 2>&1
  if [ $? -eq 0 ]; then
    pip2 install --user neovim
    pip2 install --user pyvim
  fi

  command -v pip3 >>/dev/null 2>&1
  if [ $? -eq 0 ]; then
    pip3 install --user neovim
    pip3 install --user pyvim
  fi

  # sed -e 's/^let g:python_host_prog/" let g:python_host_prog/g' \
  #   -e 's/^let g:python3_host_prog/" let g:python3_host_prog/g' \
  #   -e 's/^let g:ruby_host_prog/" let g:ruby_host_prog/g'       \
  #   -i.bak                                                      \
  #   ~/.vimrc.after
}


dir_exists() {
  [ -d "${1}" ]
}

path_contains() {
  echo $PATH | grep -q "${1}"
}

append_path() {
  dir_exists "${1}" || return 1

  path_contains "${1}" || export PATH="${PATH}:${1}"
}

prepend_path() {
  dir_exists "${1}" || return 1

  path_contains "${1}" || export PATH="${1}:${PATH}"
}

remove_from_path()
{
  path_contains "${1}" || return 0

  # no reason to remove a path entry if the user didn't pass any data
  [ -n "${1}" ] || return 0

  # remove the un-wanted path item
  local updated_path=$(echo "${PATH}" | sed -e "s|${1}:||g")

  export PATH="${updated_path}"
}

enable_proxy() {
  # Proxy Info
  export HTTP_PROXY="http://${PROXY_HOST}:${PROXY_PORT}"
  export http_proxy="${PROXY_HOST}:${PROXY_PORT}"
  export HTTPS_PROXY="https://${PROXY_HOST}:${PROXY_PORT}"
  export https_proxy="${PROXY_HOST}:${PROXY_PORT}"
  export NO_PROXY="localhost"
  export ALL_PROXY="${PROXY_HOST}:${PROXY_PORT}"

  git config --global http.proxy  "http://${PROXY_HOST}:${PROXY_PORT}"
  git config --global https.proxy "https://${PROXY_HOST}:${PROXY_PORT}"

  touch ~/.curlrc
  sed -i -e.bak '/^proxy/d' ~/.curlrc
  echo "proxy $HTTP_PROXY" >> ~/.curlrc
}

disable_proxy() {
  git config --global --unset http.proxy
  git config --global --unset https.proxy

  unset ALL_PROXY
  unset all_PROXY
  unset HTTP_PROXY
  unset http_proxy
  unset HTTPS_PROXY
  unset https_proxy
  unset NO_PROXY
  unset no_proxy

  touch ~/.curlrc
  sed -i '.bak' '/^proxy/d' ~/.curlrc
}

show_proxy() {
  env | egrep -i '^(https?_proxy|no_proxy)'
}

enable_docker_machine() {
  eval "$(docker-machine env default)"
}

disable_docker_machine() {
  unset DOCKER_TLS_VERIFY
  unset DOCKER_HOST
  unset DOCKER_CERT_PATH
  unset DOCKER_MACHINE_NAME
  unset COMPOSE_CONVERT_WINDOWS_PATHS
}

autoproxy() {
  [ -n "${VPN_PIDS}" ] && enable_proxy || disable_proxy
}

## main ##

# attempt autoproxy
# autoproxy

[ -f ${HOME}/.aliases ] && . ${HOME}/.aliases
[ -f ${HOME}/.bash_prompt ] && . ${HOME}/.bash_prompt
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f /usr/local/etc/profile.d/bash_completion.sh ] && . /usr/local/etc/profile.d/bash_completion.sh

# export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
export EDITOR=$(command -v nvim || command -v vim || command -v vi 2>>/dev/null)
export CFLAGS='-O2'
# export PYENV_ROOT="${HOME}/.pyenv"
export COMPOSE_BAKE=true

[ -f /usr/local/etc/bash_completion.d/docker-machine.bash ] && . /usr/local/etc/bash_completion.d/docker-machine.bash
[ -f /usr/local/etc/bash_completion.d/docker-machine-prompt.bash ] && . /usr/local/etc/bash_completion.d/docker-machine-prompt.bash
[ -f /usr/local/etc/bash_completion.d/docker-machine-wrapper.bash ] && . /usr/local/etc/bash_completion.d/docker-machine-wrapper.bash
[ -f /usr/local/etc/bash_completion.d/docker-compose ] && . /usr/local/etc/bash_completion.d/docker-compose

[ -S /var/run/docker.sock ] && export DOCKER_HOST="unix:///var/run/docker.sock"

[ -z "${ACTIVE_RUBY}" ] || activate_ruby

[ -d "${HOME}/lib/arduino-ide" ] && export PATH="${HOME}/lib/arduino-ide/:${PATH}" || true

# [ -d "${HOME}/miniconda3" ] && export PATH="${HOME}/miniconda3/bin:${PATH}"

[ -d "${HOME}/.gem/ruby/3.0.0/bin" ] && export PATH="${HOME}/.gem/ruby/3.0.0/bin:${PATH}" || true
