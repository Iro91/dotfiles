# Iro's dotfiles

## Installation
To install run the following:

```bash
gh repo clone Iro91/dotfiles ~/dev/dotfiles
~/dev/dotfiles/setup.sh
```

This script expectes that the home repository does not have any conflicting
files. The only exception that is made is `$HOME/.bashrc`. This file will be 
renamed to `$HOME/.bashrc.orig`. If any other conflict is found during the 
process of unstowing content, the script will fail.

When completed this will have:
- Generated folders that would otherwise be symlinked by stow
- Installed the debians listed in `pkg.list`
- Pulled git packages required to configure nvim and xterm

This is still a work in progress and since nobody but me will be making
modifications, I'll be modifying this to my hearts content. Cheers!
