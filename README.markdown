# Recent Downloads Workflow
This is an [Alfred v2](http://www.alfredapp.com) workflow to access
the most recent downloads in the Downloads folder.

The items are sorted in decreasing order based on the time they
are added to the folder. There are two operations on the selected item:

1. open with default application (default)
2. reveal in Finder (with "option" key)

# Installation
The scripts in the workflow use Ruby gems 'amatch' and 'nokogiri',
so please make sure they are installed:

```sh
sudo /usr/bin/gem install amatch nokogiri
```

Then

1. Download and unpack the .zip archive.
2. Double-click the "Recent Downloads.alfredworkflow" to install.

# Acknowledgement
This workflow uses [alfred_feedback.rb](https://gist.github.com/4555836)
with some modifications to make it compatible with Ruby 1.8.7.
