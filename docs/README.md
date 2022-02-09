![logo](https://github.com/Bash-it/media/raw/master/media/Bash-it.png)

![Build Status](../../../workflows/CI/badge.svg?event=push)
![Docs Status](https://readthedocs.org/projects/bash-it/badge/)
![License](https://img.shields.io/github/license/Bash-it/bash-it)
![shell](https://img.shields.io/badge/Shell-Bash-blue)
[![Join the chat at https://web.libera.chat/?channel=#bash-it](https://img.shields.io/badge/chat-on%20Libera.Chat-brightgreen.svg)](https://web.libera.chat/?channel=#bash-it)

**Bash-it** is a collection of community Bash commands and scripts for Bash 3.2+.
(And a shameless ripoff of [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) :smiley:)

Includes autocompletion, themes, aliases, custom functions, a few stolen pieces from Steve Losh, and more.

Bash-it provides a solid framework for using, developing and maintaining shell scripts and custom commands for your daily work.
If you're using the _Bourne Again Shell_ (Bash) regularly and have been looking for an easy way on how to keep all of these nice little scripts and aliases under control, then Bash-it is for you!  
Stop polluting your `~/bin` directory and your `.bashrc` file, fork/clone Bash-it and start hacking away.

- [Main Page](https://bash-it.readthedocs.io/en/latest)
- [Contributing](#contributing)
- [Installation](#installation)
  - [Install Options](https://bash-it.readthedocs.io/en/latest/installation/#install-options)
  - [via Docker](https://bash-it.readthedocs.io/en/latest/installation/#install-using-docker)
  - [Updating](https://bash-it.readthedocs.io/en/latest/installation/#updating)
- [Help](https://bash-it.readthedocs.io/en/latest/misc/#help-screens)
- [Search](https://bash-it.readthedocs.io/en/latest/commands/search)
  - [Syntax](https://bash-it.readthedocs.io/en/latest/commands/search/#syntax)
  - [Searching with Negations](
  https://bash-it.readthedocs.io/en/latest/commands/search/#searching-with-negations)
  - [Using Search to Enable or Disable Components](https://bash-it.readthedocs.io/en/latest/commands/search/#using-search-to-enable-or-disable-components)
  - [Disabling ASCII Color](https://bash-it.readthedocs.io/en/latest/commands/search/#disabling-ascii-color)
- [Custom scripts, aliases, themes, and functions](
  https://bash-it.readthedocs.io/en/latest/custom)
- [Themes](https://bash-it.readthedocs.io/en/latest/themes)
- [Uninstalling](https://bash-it.readthedocs.io/en/latest/uninstalling)
- [Misc](https://bash-it.readthedocs.io/en/latest/misc)
- [Help Out](https://bash-it.readthedocs.io/en/latest/#help-out)
- [Contributors](#contributors)

## Installation

There are currently two recommended ways you can employ to install Bash it

### Direct install

Using bash and curl automagically install Bash it directly from the master repository on github.

Copy and paste the following command anywhere into a shell. Curl will retrieve the install script which then gets parsed and executed by bash. On detection of the direct installation process `install.sh` will first clone the repository into `~/.bash_it` before continuing with the installation.

1. Execute the install script directly from github:
```
bash -c "$(curl -s https://raw.github.com/bash-it/bash-it/master/install.sh)"
```

2. Edit your `~/.bashrc` file in order to customize Bash it.

### Manual install

Using the same `install.sh` script by which the direct install is accomplished after manually cloning the repository first. You would probably want to check bash-it out into the folder `~/.bash_it` but anywhere else you choose also dosen't matter. The `install.sh` script will detect the location it is executed from.

1. Check out a clone of the bash-it repository:
```
git clone http://github.com/bash-it/bash-it.git ~/.bash_it
```

2. Run the `install.sh` script (it automatically backs up your `~/.bashrc`):
```
~/.bash_it/install.sh
```

3. Edit your `~/.bashrc` file in order to customize Bash it.

### That's it! :smiley:

You can check out more components of Bash-it, and customize it to your desire.  
For more information, see detailed instructions [here](https://bash-it.readthedocs.io/en/latest/installation/).

## Contributing

Please take a look at the [Contribution Guidelines](https://bash-it.readthedocs.io/en/latest/contributing) before reporting a bug or providing a new feature.

The [Development Guidelines](https://bash-it.readthedocs.io/en/latest/development) have more information on some of the internal workings of Bash-it,
please feel free to read through this page if you're interested in how Bash-it loads its components.

## Contributors

[List of contributors](https://github.com/Bash-it/bash-it/contributors)

## License

Bash-it is licensed under the [MIT License](https://github.com/Bash-it/bash-it/blob/master/LICENSE).
