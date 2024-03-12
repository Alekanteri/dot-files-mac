# Configuration files

## Installaiton

If you want to install all files from this repository, just clone all of this to `.config` directory

```sh
git clone --depth 1 https://github.com/Alekanteri/dot-files-mac.git .config
```

If you want to install only one config, you need use this script

```sh
git clone --depth 1 https://github.com/Alekanteri/dot-files-mac.git .config/[directory_name]

cd .config/[directory_name]

git filter-branch --prune-empty --subdirectory-filter [directory_name] HEAD
```

### For Example
```sh
git clone --depth 1 https://github.com/Alekanteri/dot-files-mac.git .config/nvim

cd .config/nvim

git filter-branch --prune-empty --subdirectory-filter nvim HEAD
```
