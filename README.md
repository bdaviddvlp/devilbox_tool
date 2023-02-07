# Devilbox tool

### Installation

---

* Copy the `handle-docker.sh` file to your devilbox root or clone this repo and create symlink to devilbox root
* Add `$DEVILBOX_PATH` and `devilbox-tool()` function in your `.bashrc` or `.zshrc` etc. as the following:

```
export DEVILBOX_PATH=path/to/devilbox/root

devilbox-tool() {
  bash $DEVILBOX_PATH/handle-docker.sh $@
}
```

### Usage

---
See in the help menu

`devilbox-tool --help`

### Dependencies

---
* [Devilbox](https://github.com/cytopia/devilbox)

### Note

---
This script assumes that you already have the following files in devilbox root:
* `.env7`
* `.env8`
* `docker-compose.yml.up`

If these files are missing, the script won't work properly.