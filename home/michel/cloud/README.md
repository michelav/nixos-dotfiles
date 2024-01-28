# Cloud Services

Here are some configured cloud services.

## AWS

The config is stored out of repository. Mount or symlink it into home directory
if wanna use aws.

```sh
bindfs -o fsname='/persist/user/.aws' '/persist/user/.aws' '/home/user/.aws'
```

## Dropbox

I'm using [Maestral](https://maestral.app) to sync Dropbox. To configure you should
start it in command line and acquire a token ```maestral start --foreground```.
You must configure a keyring or the token will be stores as plain text in file system.
