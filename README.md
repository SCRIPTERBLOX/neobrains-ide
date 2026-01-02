# Neobrains IDE

A neovim config attempting to be as close to a Jetbrains IDE as makes sense.. or at least providing decent integration with stuff you are probably using.

## Setup

### Install dependancies

#### Arch

```bash
sudo pacman -S nvim git
yay -S neovim-web-devicons-git
```

*I am sure at this moment there are more dependancies but because I am to lazy to figure out how to find that out you will need to tell me (open an issue).*

#### Ubuntu

```bash
sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo apt update
sudo apt install neovim git
```

#### Debian

*Make an issue detailing what you found out to be a dependancy because I dont have a Debian install so I wouldnt know.*

#### Fedora

*Make an issue detailing what you found out to be a dependancy because I dont have a Fedora install so I wouldnt know.*

### Install a nerd font

Go to https://nerdfonts.com/font-downloads, choose the font you like and install it.

*You will also need to configure your terminal emulator to use the nerd font*

### Clone the config

```bash
git clone https://github.com/SCRIPTERBLOX/neobrains-ide ~/.config/nvim && nvim
```

You will need to close the editor once before it works because it will first throw an error.

## Post install

### Delete the .git directory

If you want to change the configruation you probably want to do this.

```bash
rm -rf ~/.config/nvim/.git
```

### Structure

All keybinds are located within `~/.config/nvim/neobrains-config/keybinds.lua` for easy access and specific formatting so that I can have an in editor keybind changing UI.

Because this is Neovim plugins and configs are divided into `~/.config/nvim/lua/plugins` and `~/.config/nvim/lua/config`.

In the plugins directory each file is either for installing one plugin and configuring it to amongst other things use the keybinds defined in `~/.config/nvim/neobrains-config/keybinds.lua` or the same for multiple plugins.

In the config directory its mainly just as you would guess configuring installed plugins some more.

***You probably should not be modifying `~/.config/nvim/lua/config/lazy.lua` unless you are exactly sure how because it is responsible for making sure all of the plugins holding the editor together are installed and used.***

## Credits

Thanks to [NvChad](https://nvchad.com) for their lsp and autocomplete setup
This project amongst many other amazing plugins uses
 + [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)
 + [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
 + [mason.nvim](https://github.com/mason-org/mason.nvim) for the incredible lsp managing
