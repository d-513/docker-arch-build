# docker-arch-build

A docker-based container to build Arch Linux packages, e.g from the AUR.

## Get started

```yaml
version: "3.5"
services:
  archbuild:
    build: .
    environment:
      - MODE=standalone
    volumes:
      - ./build:/build
      - ./repo:/repo
      - ./config:/config
```

</details>

## Volumes

| **VOLUME** | **DESCRIPTION**                        |
| ---------- | -------------------------------------- |
| /build     | Folder in which packages will be built |
| /repo      | Pacman repository                      |
| /config    | Configuration files                    |

## Config

| **ENV**       | **DEFAULT**                     | **DESCRIPTION**                                                                       |
| ------------- | ------------------------------- | ------------------------------------------------------------------------------------- |
| OPTIMIZATIONS | yes                             | Whether to add MAKEFLAGS="-j$(nproc)" to makepkg.conf automatically (yes/no)          |
| MODE          | -                               | `cron` to run a crontab with periodic rebuild of packages, `standalone` to build once |
| CRON_SCHEDULE | 0 \* \* \* \* (aka. every hour) | Custom rebuild time when using the `cron` mode                                        |

| **FILE**             | **DESCRIPTION**                                                                                                                 |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| /config/gpg.key      | The armored GPG key (exported with `gpg --armor --export-secret-keys`) to be used for signing packages                          |
| /config/makepkg.conf | The `/etc/makepkg.conf` arch config file. Likely changes to it aren't needed as the container tries to use reasonable defaults. |
| /config/packagelist  | Plaintext list of GIT URL's for packages to be built, separated by newlines.                                                    |
