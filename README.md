# nvim 0.12+ frameworkless config

Well, I went down that road again...  
Following nvim 0.11's simplified LSP setup and nvim 0.12's new [native package manager](https://neovim.io/doc/user/pack.html), I decided to start from scratch.  
I took my current setup, based on AstroNvim, and tried to reproduce what I used the most while keeping the setup lightweight and simple.

My goals were:

- Fully-featured LSP setup.
- Keep a low startuptime even though pack has no lazy loading (yet?).
- Try to reduce the numbers of plugins (~25)
- Choose my own keymaps for everything (which actually led to not so many).

To accomplish that, I:

- Used nvim 0.11 and 0.12 new features.
- Identified what features I actually use and really need, allowing to eliminate some plugins.
- Replaced fancy plugins with native solutions (neo-tree/oil.nvim -> netrw, Quickterm -> terminal) and a bit of Lua scripting.

There are some choices I'm not fully decided yet, mainly:

### nvim-lspconfig / mason / mason-lspconfig / mason-tool-installer

Basically, those plugins are just utilities to simplify the setup. Once the setup is done, they are not useful anymore.  
**nvim-lspconfig** is a data repo only, it provides LSP configs so you don't have to get or create them yourself.  
**mason** actually installs those LSP servers for you, so you don't have to download them yourself. Also provides a GUI.  
**mason-tool-installer** installs additional tools other than LSP servers, like formatters, linters, DAP debuggers, etc (e.g `golanglint-ci`, `goimports`).  
**mason-lspconfig** allows to use the LSP server names of `nvim-lspconfig` instead of Mason's names (lua_ls <-> lua-language-server), and automatically enables the LSP servers. Before nvim 0.11 it did a lot of work, now it's only that.

So it's only about installing, providing configuration, and enabling. The actual work is done by nvim and the LSP servers themselves. For now I will keep this so I can easily install new servers / tools, but I might remove this fancy tooling and just do the work manually, especially if I don't find myself installing new ones regularly.  
**nvim-lspconfig** can be replaced by manual download or a simple script (see [edr3x's work](https://github.com/edr3x/nvim/blob/main/getlsp)).  
**mason** and **mason-tool-installer** can also be replaced by manual download.  
**mason-lspconfig** can be replaced by using the proper names and [`vim.lsp.enable({"foo", "bar", ...})`](<https://neovim.io/doc/user/lsp.html#vim.lsp.enable()>).

A possible compromise could be to load these plugins only when needed, via a defined command, which would call `vim.pack.add({...})` and the setups.

### Multi-files vs single-file

I'm mitigated. Multi-files may be better organized, but sometimes creates dependency problems. It may be great for readabilty, but also forces to jump between files (e.g from plugins.lsp to lsp.lua).  
Single-file is just simple, it just works, and is easier to share, maybe to navigate.

As a compromise, I created a [`flatten.lua`](.flatten.lua) script which parses `init.lua` and inlines the `require(<module>)` by their content.  
It is designed to be ran with Neovim's embedded Lua: `nvim --headless -l flatten.lua > init_flattened.lua`.
