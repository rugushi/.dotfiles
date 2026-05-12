## 1. Install XCode:
   `xcode-select --install`
## 2. Clone this repo:
   `git clone git@github.com:rugushi/.dotfiles.git`
## 3. Add container SSH configuration

in `/ssh/config`:

```
Host localhost
    HostName 127.0.0.1
    User root
    IdentityFile ~/.ssh/id_dev_container
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    IdentitiesOnly yes
```
