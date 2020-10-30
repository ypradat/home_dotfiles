# Dotfiles

This repository contains configuration files that you would normally find into `$HOME` folder as cached files. These
files are in my case located into this repository so that I can have them under version control for easier sharing
between multiple platforms. In order for the local OS to use these files, please create symlinks from these files to
your `$HOME`.


## .vimrc

Contains my complete configuration of vim plugins and key bindings. Some plugins may not be appropriate on clusters
where the system may not have certain softwares for which I have installed plugins or may have outdated versions of
dependencies (including vim) that causes certain plugins to not work.

- YouCompleteMe: requires Vim >= v8.1.2269, Python >= 3.6 runtime. Installation requirements further detailed at
  [youcompleteme](https://github.com/ycm-core/YouCompleteMe#macos)

- vim-tmux-navigator:  requires tmux >= v1.8. Configure your `.tmux.conf` file to include

    ```
    # Smart pane switching with awareness of Vim splits.
    # See: https://github.com/christoomey/vim-tmux-navigator
    is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
    bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
    bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
    bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
    bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
    tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
    if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
    if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

    bind-key -T copy-mode-vi 'C-h' select-pane -L
    bind-key -T copy-mode-vi 'C-j' select-pane -D
    bind-key -T copy-mode-vi 'C-k' select-pane -U
    bind-key -T copy-mode-vi 'C-l' select-pane -R
    bind-key -T copy-mode-vi 'C-\' select-pane -l
    ```

## .tmux.conf

- To activate the powerline on tmux sessions

    ```
    # Run powerline-daemon and source powerline.conf
    run-shell "powerline-daemon -q"
    source "/usr/local/lib/python3.7/site-packages/powerline/bindings/tmux/powerline.conf"
    ```

- Activate vi setup

    ```
    # Set vi mode
    set-window-option -g mode-keys vi
    set -g status-keys vi
    ```

## .zshrc

ZSH is an extended version of the Bourne Shell with support for plugins and themes.
- Conda activation: package management system and environment management system

    ```
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/usr/local/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/usr/local/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/usr/local/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/usr/local/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
    ```

- Oh-My-Zsh: The most popular plugin framework for ZSH is Oh-My-Zsh.

    ```
    # Path to your oh-my-zsh installation.
    export ZSH="$ZSH/.oh-my-zsh"
    ```

- Asdf config: Install [asdf](https://github.com/asdf-vm/asdf). I installed v0.8.0 with `brew` so the binaries are in
`/usr/local/opt/asdf`

    ```
    # Asdf config
    . /usr/local/opt/asdf/asdf.sh
    ```

## .skimeditor.sh

Configuration file copied from [Skim wiki](https://sourceforge.net/p/skim-app/wiki/TeX_and_PDF_Synchronization/) to
activate Tex and Pdf synchronization. Additionally, in Skim > Preferences > Sync, you need to setup the options
Preset = `Custom`, Command = `$HOME/.skimeditor.sh` and Arguments = `"%file" %line`.

With this setting and the `vimtex` vim plugin set to use `Skim`, forward search works perfectly.

## .condarc

Only contains a command for not activate the base environment by default.

## .ctags

Configuration and installations copied from
[Fong Chun Chan's Blog](https://tinyheero.github.io/2017/05/13/r-vim-ctags.html).

## .bash_profile

Previous configuration file that is not used anymore as the default shell is now zsh.
