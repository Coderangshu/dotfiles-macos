# Dotfiles for my Mac Setup  
Steps for setting it up in new system:
1. Set this alias in .zshrc ```alias track='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'```
2. In home directory ```echo ".cfg" >> .gitignore```
3. ```git clone --bare git@github.com:Coderangshu/dotfiles-macos.git $HOME/.cfg```
4. ```alias track='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'```
5. ```track checkout```
6. ```track config --local status.showUntrackedFiles no```

# Applications to install
1. AppCleaner
2. BetterDisplay
3. btop
4. colima
5. felixKratz/borders
6. lf
7. neovim
8. skhd
9. trash
10. yabai
11. ls
