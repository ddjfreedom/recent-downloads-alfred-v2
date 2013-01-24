# Recent Downloads Workflow
This is an [Alfred v2](http://www.alfredapp.com) workflow to access
the most recent downloads in the Downloads folder.

The items are sorted in decreasing order based on the time they
are added to the folder. The item is filtered by testing whether
the query is a subsequence (need not be consecutive) of it.  

There are two operations on the selected item:

1. open with default application (default)
2. reveal in Finder (holding "option" key)
3. delete (holding "ctrl" key)
4. move to trash (holding "cmd" key)

# Installation

1. Download and unpack the .zip archive.
2. Double-click the "Recent Downloads.alfredworkflow" to install.

# Acknowledgement
This workflow uses [alfred_feedback.rb](https://gist.github.com/4555836)
with some modifications to make it compatible with Ruby 1.8.7.
