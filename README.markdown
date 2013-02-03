# Recent Downloads Workflow
This is an [Alfred v2](http://www.alfredapp.com) workflow to access
the most recent downloads in the Downloads folder.

The items are sorted in decreasing order based on the time they
are added to the folder. The item is filtered by testing whether
the query is a subsequence (need not be consecutive) of it.

There are two operations on the selected item:

1. open with default application (default)
   - if the item can be installed (an application, an dmg file, a zip
   file containing those files, etc), the workflow will prompt the user
   whether to install it. After the installation, if the item installed
   is an application, the workflow will prompt the user whether to launch
   it
2. reveal in Finder (holding "option" key)
3. delete (holding "ctrl" key)
4. move to trash (holding "cmd" key)

The installation behavior can be controlled by `config.yaml` at
`~/Library/Application Support/Alfred 2/Workflow Data/recentdownloads.ddjfreedom/config.yaml`:

| Name | Possible Values |
|:-----|:----------------|
| `install_action` | `ask`, `install`, `open` |
| `auto_start` | `ask`, `always`, `never`|
| `subfolders` | `:all`, `:none`, a list of entries |

## Subfolders
Recent Downloads workflow can display items in some specified subfolders along with everything in `~/Downloads`. The value for `subfolders` in `config.yaml` can be `:all`, `:none`, or a list of entries. Each entry can be a path or a hash:

```no-highlight
folder: <path, :all, or :none>
depth: <a number >= 1> (default to 1)
exclude: <true or false> (default to false)
```
where `depth` controls how deep to go down the file system tree starting from `folder`, and `exclude` controls whether the `folder` itself is included in the result. `:all` and `:none` will override all other settings (whichever appears first).

### Examples
Suppose `~/Downloads` is as following
```no-highlight
+-~/Downloads
  +-a/
  | +-aa.pdf
  | +-ab/
  |   +-pic.jpg
  |   +-e/
  |     +-f.img
  +-b/
  | +-ba/
  |   +-baa/
  |   | +-foo/
  |   | |   +-bar.c
  |   | +-bar/
  |   |   +-foo/
  |   |     +-foo.c
  |   +-bab.xml
  +-c/
    +-imgs/
      +-img.png
```
If `config.yaml` has the following value
```no-highlight
subfolders:
-
    folder: "a"
    exclude: false
    depth: 2
-
    folder: "b"
    exclude: true
-
	"c"
```
the result will be
```no-highlight
a, a/aa.pdf, a/ab, a/ab/pic.jpg, a/ab/e
b/ba
c, c/imgs
```
# Installation
## AlfPT
Recent Downloads is now on AlfPT:

    `alfpt install Recent Downloads`

## Manual
1. Download and unpack the .zip archive.
2. Double-click the "Recent Downloads.alfredworkflow" to install.

# Acknowledgement
This workflow uses [alfred_feedback.rb](https://gist.github.com/4555836)
with some modifications to make it compatible with Ruby 1.8.7.
The script for installation is written by Okke Tijhuis ([@otijhuis](https://twitter.com/@otijhuis),
[otijhuis.tumblr.com](http://otijhuis.tumblr.com)), and [David](http://jdfwarrior.tumblr.com).
