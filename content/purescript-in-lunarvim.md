---
{
  "author": "Andres Otarola",
  "title": "🌚 LunarVim + Purescript + LSP",
  "description": "How to get a working lsp for Purescript in LunarVim",
  "image": "v1627861555/elm-pages/article-covers/photo-1471107340929-a87cd0f5b5f3_mczjfg.jpg",
  "published": "2022-05-15",
}
---

Being a die-hard fan of coding in [`(neo)vim`][neovim], I've been forced myself to look for the perfect (or at the very least _decent_)
configuration of a development environment for my language of choice, or the one I'm currently learning, which in this case is `purescript`.

The present post's goal is to shed some light on certain tooling that exist today but they are probably not
widely known; such as [`LunarVim`][lvim], and also keep a record for myself for _how the hell did I 
configure this!?_ 😜

[neovim]: https://neovim.io/
[lvim]: https://github.com/LunarVim/LunarVim

## What is LunarVim

My main (and pretty much only) editor today is [`LunarVim`][lvim] (for both work and personal stuff), 
the reason I stuck with it instead of my own neovim configuration, is because I like the defaults of the editor and the nice automation it has when adding a new treesitter language or a new lsp implementation.

So if that picked your interest, you should definitely [give it a try!][lvim-install], the cool thing is that it won't
interfere with your current neovim install 😉.

[lvim-install]: https://github.com/LunarVim/LunarVim#install-in-one-command

## Why LSP

For every language that I work I **NEED** to have an implementation of a 
[language server protocol (LSP)][lsp] for it (or similar), I just need to get a feeling of _some standard 
automated process will assist me on my coding_, including simple stuff such as Dockerfile or mardown files
(yes, I want it to be autoformatted for me, that is how lazy I am!)

[lsp]: https://langserver.org/

## How to get it working 💚

### 1. Configure your LunarVim

Make sure you have [installed][lvim-install] `LunarVim`.

[`LunarVim`][lvim] uses [`treesitter`][treesitter] in order to detect file types, and it also includes advanced syntax 
highlighting via the included plugin [`nvim-treesitter`][nvim-treesitter]. But, as of now, it only supports a [fixed set of languages][supported-langs], which does not include `purescript` 😭

But fear not, you an easily fall back to a super popular plugin, called `vim-polyglot`.

Add the following in your `~/.config/lvim/config.lua`

```
lvim.plugins = {
  -- rest of plugins ...  
  { "sheerun/vim-polyglot" },
  { "purescript-contrib/purescript-vim" },
}
```

Now you have proper file type detection and syntax highlighting!.

[treesitter]: https://tree-sitter.github.io/tree-sitter/
[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[supported-langs]: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages

### 2. Create a `Purescript` project

The tooling that I use for a `purescript` project are `purescript` (surprise!) and `spago`, so proceed to install then if
you don't have them:

```
$ brew install purescript spago
$ mkdir hello-world-ps
$ cd hello-world-ps
$ spago init
$ spago run
```

Open the created file: 

```
$ lvim src/Main.purs
``` 

`LunarVim` will detect the file type and download the proper `LSP`, in this case is 
[`purescriptls`][pursls] automatically, and... that's it!, really!, enjoy! 😁


![StaticHttp content request](/images/purescript-in-lunarvim/lsp-shot.png)

[pursls]: https://github.com/nwolverson/purescript-language-server
