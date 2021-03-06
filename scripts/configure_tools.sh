#!/bin/bash

function restore_settings {
  info 'Restoring app settings.'
  ruby "${HOME}/Library/Mobile Documents/com~apple~CloudDocs/Tape/tape" restore
}

function set_keyboard_shortcuts {
  info 'Setting custom keyboard shortcuts.'
  # Custom keyboard shortcuts for apps
  # @ is ⌘; ~ is ⌥; $ is ⇧; ^ is ⌃
  # Read more at https://web.archive.org/web/20140810142907/http://hints.macworld.com/article.php?story=20131123074223584

  # Global
  # defaults write -g NSUserKeyEquivalents '{}'

  # Contacts
  defaults write com.apple.AddressBook NSUerKeyEquivalents '{
    "Edit Card"="@E";
  }'

  # Reeder
  defaults write com.readerapp.macOS NSUserKeyEquivalents '{
    "Close Window"="@w";
  }'

  # Safari
  defaults write com.apple.Safari NSUserKeyEquivalents '{
    "Show Previous Tab"="@~\Uf702";
    "Show Next Tab"="@~\Uf703";
  }'

  defaults write com.apple.SafariTechnologyPreview NSUserKeyEquivalents '{
    "Show Previous Tab"="@~\Uf702";
    "Show Next Tab"="@~\Uf703";
  }'

  # ScreenFlow 5
  defaults write net.telestream.screenflow5 NSUserKeyEquivalents '{
    "Add Screen Recording Action"="~r";
    "Split Clip"="s";
  }'
}

function set_default_apps {
  info 'Setting default apps.'

  # Make Spotlight aware of mpv
  if [[ -z "$(mdfind kMDItemCFBundleIdentifier = 'io.mpv')" ]]; then
    mdimport -i "$(find "$(brew --prefix)" -type d -name 'mpv.app' | tail -1)"
  fi

  # General extensions
  for ext in {aac,avi,f4v,flac,m4a,m4b,mkv,mov,mp3,mp4,mpeg,mpg,ogg,part,wav,webm}; do duti -s io.mpv "${ext}" all; done # Media
  for ext in {7z,bz2,gz,rar,tar,tbz,tgz,zip}; do duti -s com.aone.keka "${ext}" all; done # Archives
  for ext in {cbr,cbz}; do duti -s com.richie.YACReader "${ext}" all; done # Image archives
  for ext in {md,txt}; do duti -s pro.writer.mac "${ext}" all; done # Text
  for ext in {css,js,json,php,pug,py,rb,sh}; do duti -s com.microsoft.VSCode "${ext}" all; done # Code

  # Affinity apps (use beta versions when possible)
  for ext in {afdesign,eps}; do duti -s com.seriflabs.affinitydesigner "${ext}" all; done
  for ext in {afphoto,psd}; do duti -s com.seriflabs.affinityphoto "${ext}" all; done
}

function configure_git {
  ask 'Request a GitHub token for `cli-approve-button`.'
  cli-approve-button --ensure-token
  ask 'Request a GitHub token for `cli-merge-button`.'
  cli-merge-button --ensure-token
}

function install_editor_packages {
  info 'Installing Neovim packages.'
  curl --silent --location 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' --output "${HOME}/.local/share/nvim/site/autoload/plug.vim" --create-dirs
  nvim +PlugInstall +qall > /dev/null

  info 'Skipping atom packages for now.'

  info 'Installing VSCode packages.'
  code --install-extension dbaeumer.vscode-eslint gerane.Theme-Peacock misogi.ruby-rubocop timonwong.shellcheck vscodevim.vim
}

function configure_pinboard_scripts {
  local pinboard_token
  ask 'Give Pinboard token for configuration of personal Pinboard scripts:'
  read -rp 'Pinboard token: ' pinboard_token

  pinboardlinkcheck --save-token --token "${pinboard_token}"
}

function install_chromium_extensions {
  ask_chromium 'Google Chrome' '1Password extension' 'aomjjhallfgjeglblehebfpbcfeobpgk'
  ask_chromium 'Google Chrome' 'uBlock Origin' 'cjpalhdlnbpafiamejdnhcphjbkeiagm'
  ask_chromium 'Google Chrome' 'Unsplash Instant' 'pejkokffkapolfffcgbmdmhdelanoaih'

  ask_gui 'Remove Google-imposed extensions.' 'Google Chrome'
}

function install_alfred_workflow_launch_agents {
  info 'Setting up Alfred Workflow launch agents.'

  /usr/bin/osascript -e 'tell application id "com.runningwithcrayons.Alfred" to run trigger "downmediaservicesinstall" in workflow "com.vitorgalvao.alfred.downmedia" with argument "install"'
  /usr/bin/osascript -e 'tell application id "com.runningwithcrayons.Alfred" to run trigger "pinpluslaunchdinstall" in workflow "com.vitorgalvao.alfred.pinplus" with argument "install"'
  /usr/bin/osascript -e 'tell application id "com.runningwithcrayons.Alfred" to run trigger "shortfilmslaunchdinstall" in workflow "com.vitorgalvao.alfred.shortfilms" with argument "install"'
}
