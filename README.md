<!-- 🐀🐁🐂🐃🐄🐅🐆🐇🐈🐉🐊🐋🐌🐍🐎🐏🐐🐑🐒🐓🐔🐕🐖🐗🐘🐙🐚🐛🐜🐝🐞🐟🐠🐡🐢🐣🐤🐥🐦🐧🐨🐩🐪🐫🐬🐭🐮🐯🐰🐱🐲🐳🐴🐵🐶🐷🐸🐹🐺🐻🐼🐽 -->
# About ZooVim

You may find most of my autoload plugin's name relative to a creature, so I
named it ZooVim.

ZooVim's mainly purpose is let vim be (or most likely be) a generic code editor,
more than the text editor. ZooVim is my personal vim configure for daily use.
ZooVim don't provide any plugin in plugin dir, all it provide
is a bunch of autoload files, some script tools and an example of vimrc (entry.zoovim).
ZooVim is not one-stop shop for vim configure, you should tailored my example vimrc
to fit your needs.

**CAUTION 1**: some autoload file auto changes vim's default option that could
harassd you, before you use it, read the DESCRIPTION, and lines begin with
`set` in every autoload file.

**CAUTION 2**: some feature still in building, use at your own discretion!


# Features

- auto popup complete-menu (provider 'ape.vim')
- complete command line option, current only for git & pandoc (provider 'cat.vim')
- enhanced status line, not brilliant, keep attention to edit (provider 'bar.vim')
- incremental search tool, partly need external program (provider 'fenrir.vim')
- search and jump around, like 'f' for whole buffer (provider 'hunter.vim')
- simple snippet engine, inline support (provider 'snipe.vim')
- scratch buffer, for git, webclip and more (provider 'unicorn.vim')
- 3 colorschemes

# Quick Start

Before start, I assume `~/.vim` in your vim's 'runtimepath' (use `:echo &rtp`
check you runtimepath).

Here are 3 ways you can take action:

- violent replace:
 `mv ~/.vim ~/.vim_old; git clone https://github.co/zyprex/ZooVim.git ~/.vim`

- vim8's packages: `git clone https://github.co/zyprex/ZooVim.git
  ~/.vim/pack/zyprex/opt/ZooVim`, in your `.vimrc` add `packadd ZooVim` ,
  move any fold start with '\_' to `~/.vim`

- any other plugin manager is an viable option.

After you completed below step, don't forget run `:helpt ALL` in your vim.

Finally, see `entry.zoovim` or rename it to `.vimrc`.

# Usage

You will find recommend configure in each autoload file, read the description.
Generally speaking, file in autoload dir should be zero dependencies, and files
which callded `{filename}` in tools dir can only be used by
`:so ~/.vim/tools/{filename}`. Dir which name start with '\_' is used by another
autoload plugin. The "doc" dir store one cheetsheet I made for some vim tricks,
after help tags made, you can use it by ':h SOS-vim'.

# Credits

With some CLI tools, you can have better experience:

- [fd](https://github.com/sharkdp/fd): A simple, fast and user-friendly alternative to 'find'.
- [ag](https://github.com/ggreer/the_silver_searcher): the silver searcher
- [rg](https://github.com/BurntSushi/ripgrep): ripgrep
- [ctags](https://github.com/universal-ctags/ctags): universal ctags
- [curl](https://curl.se/download.html): transferring data with URL syntax
- [pandoc](https://github.com/jgm/pandoc): universal markup converter
<!-- https://www.doxygen.nl/download.html -->

Some vim plugin, that has similar or more powerful features than I did, inspired me a lot.

For 'ape.vim':

- [vim-auto-popmenu](https://github.com/skywind3000/vim-auto-popmenu)
- [vim-mucomplete](https://github.com/lifepillar/vim-mucomplete)

For 'bar.vim':

- [eleline](https://github.com/liuchengxu/eleline.vim)

For 'hunter.vim'

- [vim-sneak](https://github.com/justinmk/vim-sneak)

For 'fenrir.vim':

- [ctrlp](https://github.com/ctrlpvim/ctrlp.vim)

For 'snipe.vim':

- [vim-minisnip](https://github.com/tckmn/vim-minisnip)

For others:

- [commentary](https://github.com/tpope/commentary)
- [vim-unimpaired](https://github.com/tpope/vim-unimpaired)

The list never end.

 vim:tw=80:
