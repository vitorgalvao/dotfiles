restore_settings() {
  ruby "${HOME}/Library/Mobile Documents/com~apple~CloudDocs/darkhouse/_run_house/quick_restore.rb"
}

set_default_apps() {
  # fix duplicates in `open with`
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
  killall Finder

  # general extensions
  for ext in {aac,avi,flac,m4a,m4b,mkv,mov,mp3,mp4,mpeg,mpg,wav}; do duti -s io.mpv "${ext}" all; done # media
  for ext in {7z,bz2,gz,rar,tar,zip}; do duti -s com.aone.keka "${ext}" all; done # archives
  for ext in {css,jade,js,json,php,py,rb,sh}; do duti -s com.github.atom "${ext}" all; done # code

  # Affinity apps (use beta versions)
  duti -s com.seriflabs.affinitydesigner.beta afdesign all
  duti -s com.seriflabs.affinityphoto.beta afphoto all
}

set_keyboard_shortcuts() {
  # Custom keyboard shortcuts for apps
  # @ is ⌘; ~ is ⌥; $ is ⇧; ^ is ⌃
  # read more at https://web.archive.org/web/20140810142907/http://hints.macworld.com/article.php?story=20131123074223584

  # Global
  # defaults write -g NSUserKeyEquivalents '{}'

  # Byword
  defaults write com.metaclassy.byword NSUserKeyEquivalents '{
    "Enter Full Screen"="@^f";
    "Exit Full Screen"="@^f";
  }'

  # Tweetbot
  defaults write com.tapbots.TweetbotMac NSUserKeyEquivalents '{
    "Open Links"="l";
    "Send to Pinboard"="$l";
  }'
}

configure_zsh() { # make zsh default shell
  sudo -S sh -c 'echo "/usr/local/bin/zsh" >> /etc/shells' <<< "${sudo_password}" 2> /dev/null
  sudo -S chsh -s '/usr/local/bin/zsh' "${USER}" <<< "${sudo_password}" 2> /dev/null
}

install_zsh_plugins() {
  local zsh_plugins_dir="${HOME}/.zsh-plugins"

  # oh-my-zsh history
  curl --progress-bar --location 'https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/lib/history.zsh' --output "${zsh_plugins_dir}/oh-my-zsh-history/history.zsh" --create-dirs
  # zsh-completions
  git clone 'git://github.com/zsh-users/zsh-completions.git' "${zsh_plugins_dir}/zsh-completions"
  rm -f "${HOME}/.zcompdump"; compinit # force rebuild zcompdump
  # zsh-syntax-highlighting
  git clone 'git://github.com/zsh-users/zsh-syntax-highlighting.git' "${zsh_plugins_dir}/zsh-syntax-highlighting"
  # zsh-history-substring-search
  git clone 'git://github.com/zsh-users/zsh-history-substring-search.git' "${zsh_plugins_dir}/zsh-history-substring-search"
}

install_nvim_packages() {
  # download and configure vim-plug
  # there's a chance it won't be needed in the future (https://github.com/junegunn/vim-plug/issues/249)
  curl --progress-bar --location 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' --output "${HOME}/.nvim/autoload/plug.vim" --create-dirs
  # 'sleep' is needed now since without it '+qall' would quit before '+PlugInstall' finished (https://github.com/junegunn/vim-plug/issues/104)
  nvim +PlugInstall +"sleep 60" +qall
}

install_atom_packages() {
  # packages
  apm install atom-alignment color-picker dash esformatter git-plus highlight-line language-jade linter linter-eslint linter-jsonlint linter-rubocop linter-shellcheck merge-conflicts node-debugger p5xjs-autocomplete pigments relative-numbers seeing-is-believing vim-mode vim-surround

  # themes and syntaxes
  apm install peacock-syntax seti-ui
}

configure_git() {
  echo -e "[user]\n\tname = ${name}\n\temail = ${github_email}\n[github]\n\tuser = ${github_username}" > "${HOME}/.gitconfig"
  git config --global credential.helper osxkeychain
  git config --global push.default simple
}

install_launchagents() {
  launchagents_dir="${HOME}/Library/LaunchAgents"
  mkdir -p "${launchagents_dir}"

  for plist_file in "${helper_files}/launchd_plists"/*; do
    plist_name=$(basename "${plist_file}")

    mv "${plist_file}" "${launchagents_dir}"
    launchctl load -w "${launchagents_dir}/${plist_name}"
  done

  rmdir "${helper_files}/launchd_plists"
}
