# Witchmacs
The cutest Emacs distribution

![Witchmacs](https://github.com/snackon/Witchmacs/blob/master/gnumarisa.png)

# Introduction
Configuration files for emacs to add a cute Marisa image and a few custom snippets

# Why would I use this?
>*What's the difference between a villain and a super villain? Presentation!*

Currently, the appeal of Witchmacs is seeing a cute Marisa picture everytime you start up Emacs. Also, it is a very basic config which means you can easily add, edit or remove things as you like. You can use this as a building block when making your OWN Emacs config!

As opposed to many other Emacs distributions, Witchmacs has ZERO customization layers which means you can just jump in, look at the config file and start editing away! After all, Emacs works best when it's customized to your own liking!

# Quick install
`git clone https://github.com/snackon/Witchmacs ~/.emacs.d`

After running this command, the first time you run Emacs will download all of the specified packages in the config.org file, so please be patient!

# Dependencies
`clang` as backend for C and C++ snippets

## Experimental
I'm trying out some packages to turn Emacs into a Python IDE. If you don't want to use them, just delete anything Python related from config.org. Otherwise, run the following command in your CLI:
`pip install jedi flake8 autopep8`

# TODO
* Add and configure some extra packages
* ~~Make dashboard cooler~~
  * Make dashboard EVEN cooler!
  * Maybe add rotating dashboard pictures
* ~~Make custom Witchmacs theme~~
  * (Maybe) Make custom theme for other Marisa color schemes
* ~~Clean up/organize init.el~~
  * Clean up/organize config.org
* Optimize startup time