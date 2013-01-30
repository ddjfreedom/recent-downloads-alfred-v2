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
