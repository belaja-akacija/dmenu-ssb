# dmenu-ssb

A simple search query follower, using [dmenu](https://tools.suckless.org/dmenu/) -- (Dynamic menu for X)


## Usage

Run `ssb` in the terminal, or set a keybind to execute `ssb` and begin searching the web.

## Configuration

Set your search engine in the `*search-engine*` variable, in this format:
`https://www.search-engine.com/&options&?=`

Set your browser in the `*browser*` variable. It should be the same as the
command you would use in your shell to open the browser.

The script has the ability to store your searches in a file, but can easily be turned off
by changing `*save-search?*` to `nil`, then recompiling. *__By default, this is turned off.__*

## How to build

### Dependencies

- [SBCL](https://www.sbcl.org/platform-table.html) -- (Common Lisp implementation)
- [Quicklisp](https://www.quicklisp.org/beta/) -- (A library manager for Common Lisp)

### Instructions

Run `make build install`

**make sure `~/.local/bin/` is in your path**
