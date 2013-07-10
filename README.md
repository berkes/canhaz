# About

# Author

# Requirements

Ubuntu 11.04 minimal server install on 1gb. using one disk.
no encryption

Drupal 7.12 - default modules installed

# Install

* `sudo apt-get install rubygems`
* `gem install bundler` #This should install in userspace, if not, run as sudo
* `git clone git@github.com:berkes/canhaz.git`
* `cd canhaz`
* `bundle`

# Usage

    ./canhaz
    Tasks:
      canhaz haz URL         # find out if site at URL has imagecache
      canhaz help [TASK]     # Describe available tasks or one specific task
      canhaz hit URL AMOUNT  # hit site at URL, make it generate a total of AMOUNT images
      canhaz styles URL      # find a list of potential imagecache styles on URL

# TODOs
