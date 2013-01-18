#!/bin/bash

#############################
### Codebox               ###
#############################

# Always edit placeholders
defaults write com.shpakovski.mac.codebar AutoEditPlaceholders -bool YES


#############################
### Transmission          ###
#############################

# Set download and upload limits
defaults write org.m0k.transmission UploadLimit -int 50
defaults write org.m0k.transmission SpeedLimitUploadLimit -int 50
defaults write org.m0k.transmission SpeedLimitDownloadLimit -int 1000

# Use for directory for incomplete downloads
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true

# Trash torrent files
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# Maximum active transfers
defaults write org.m0k.transmission Queue -bool true
defaults write org.m0k.transmission QueueDownloadNumber -num 2
defaults write org.m0k.transmission QueueSeed -bool true

# Define prompts
defaults write org.m0k.transmission CheckRemoveDownloading -bool true
defaults write org.m0k.transmission CheckQuit -bool false

# Default downloads to ~/Downloads/
defaults write org.m0k.transmission DownloadLocationConstant -bool true

# Do not show 'add' window when adding downloads
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false

# Hide the donate message
defaults write org.m0k.transmission WarningDonate -bool false
# Hide the legal disclaimer
defaults write org.m0k.transmission WarningLegal -bool false