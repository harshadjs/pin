# Pin - Shell Commands Organizer

This is a simple tool to manage your day-to-day shell commands that you
probably run across multiple devices. Pin helps you remember, manage and share
these commands.

Pin is designed to be *ultra-portable*. The entire logic resides in just one shell
script that uses very basic shell commands. That allows pin to be run on a
variety of devices.

Pin lets you decide how and where you want to backup saved commands. For
example, on your primary development machine, you may want to use a git
repository or a GCS bucket to store your commands. However, on transient VMs,
you may want to just simply rely on
[the import / export functionality](#importing-and-exporting) to backup commands.

# Quick Start
Ready to give it a shot? Simply run the following command to get started:

```bash
$ curl https://raw.githubusercontent.com/harshadjs/pin/main/pin > pin; chmod +x pin
```

# What can `pin` do?

* `Pin` allows you to easily save any command by simply adding `pin run` as a
  prefix to any command that you would like to save.

* `Pin` allows you to sync your commands using your own custom sync method.
  See [syncing](#syncing) for more details.

* `Pin` allows you to execute saved commands with custom arguments.

* `Pin` allows you to export commands to [cl1p.net](http://cl1p.net) for easy
  sharing with others or with your own devices.

*  Pin stores your favorite commands as self identifiable json objects in the
   following simple format:
   ```json
   {
      "cmd": "ls --color=tty",
      "desc": "List directory with color"
   }
   ```
   These objects are identified by the `SHA1` sum of the command itself. This
   means there is no command duplication and / or no accidental overwrites
   during sharing of commands.

* `Pin` is very lightweight and portable. It can even be
  [installed without internet connectivity](#install-pin-by-base64-method) and
  has very minimal dependencies which allow it to be run in embedded
  environments as well.

# Setup

Pin can be setup in multiple ways based on how frequently you want to use it on
the device and the device configuration. If you are setting up pin on your
primary development machine, use git based method. If you are setting up pin
on a transient VM, use `curl` based method. If you are setting up pin on a
device with no internet connectivity, use base64 methood.

## Install `pin` using git

* Clone this repository.

* Run `pin` for the first time and it will configure and install itself.

  Following aliases are handy for day to day usage:

  ```bash
  alias p="pin"
  alias pr="pin run"
  ```
* Just prefix any command that you want to save by `pr`.

* (Optional) If you would like to use `sync` functionality to save your
commands somewhere, edit `pin-sync.sh` with instructions to backup the
commands. I just use another private GitHub repository.

Note: If you are not able to run `pin` on Mac, you may have to first run
`dos2unix pin` in order to match line endings.

## Install `pin` using curl

* Run the following command on the instance:

```bash
curl https://raw.githubusercontent.com/harshadjs/pin/main/pin > pin; chmod +x pin
```

* Run `pin` for the first time and it will configure and install itself.

## Install `pin` by `base64` method

* Run the following command on the instance and paste the contents of
  [pin.tar.xz.base64](https://raw.githubusercontent.com/harshadjs/pin/main/pin.tar.xz.base64) file.

```bash
$ base64 -d | tar -xzf - > pin
## Paste contents of pin.tar.xz.base64 here 
```

* Run `pin` for the first time and it will configure and install itself.

# Guide

## Basics

This section describes the basic `pin` functionalities for managing shell
commands.
#### Run and save a new command
```
$ pin run find . -name cmd
Save command [y/N]? y

Command entered: (0)find (1). (2)-name (3)cmd
Enter the indices from above command that are arguments (enter to skip): 1 3
Command to be saved: find ARG -name ARG
Short Description (enter to skip): Search files in a directory
Created e3bcc45f033a67b6ed86a7aaadfdbb6de06502b0.
Alias (enter to skip):
```

#### List saved commands
```
$ pin ls
0: ls --color=auto
1: find ARG -name ARG
```

#### Describe a saved command
```
$ pin desc 1 ## also you can pass the SHA1
SHA1: e3bcc45f033a67b6ed86a7aaadfdbb6de06502b0
Command: find ARG -name ARG
Description: Search files in a directory
```

#### Running a saved command
```bash
$ pin run 1
SHA1:           e3bcc45f033a67b6ed86a7aaadfdbb6de06502b0
Command:        find ARG -name ARG
Description:    Find by name
Executing this command...
find <Enter Value>: .
find . -name <Enter Value>: pin
find . -name pin
./pin
```

## Importing and Exporting
Pin provides multiple ways of exporting and importing command. If your devices
have internet connectivity, use the internet clipboard method. If one of your
devices doesn't have internet connectivity, use `base64` method.

#### Internet clipboard method
```bash
## Exporting
$ pin export 1
Command exported at https://api.cl1p.net/pin-e3bcc45f033a67b6ed86a7aaadfdbb6de06502b0-1608052016

## Importing on a different device
$ pin import https://api.cl1p.net/pin-e3bcc45f033a67b6ed86a7aaadfdbb6de06502b0-1608052016
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    82  100    82    0     0    181      0 --:--:-- --:--:-- --:--:--   181
Imported e3bcc45f033a67b6ed86a7aaadfdbb6de06502b0.

$ pin desc e3bcc45f033a67b6ed86a7aaadfdbb6de06502b0
SHA1:           e3bcc45f033a67b6ed86a7aaadfdbb6de06502b0
Command:        find ARG -name ARG
Description:    Find by name
```
#### base64 method
* Export the command using `export-b64` subcommand
```bash
## Exporting
$ pin export-b64 10
ewogICJjbWQiOiAiZmluZCBBUkcgLW5hbWUgQVJHIiwKICAiZGVzYyI6ICJGaW5kIGJ5IG5hbWUi
Cn0K
```
* Copy the text blurp generated above
* On the remote machine run `import-b64` subcommand and paste the blurp
```bash
$ pin import-b64
Text mode. Enter the string that you got from pin export-b64. Ctrl D to stop:
ewogICJjbWQiOiAiZmluZCBBUkcgLW5hbWUgQVJHIiwKICAiZGVzYyI6ICJGaW5kIGJ5IG5hbWUi
Cn0K
Imported e3bcc45f033a67b6ed86a7aaadfdbb6de06502b0.
```
* Describe the newly imported command
```bash
$ pin desc e3bcc45f033a67b6ed86a7aaadfdbb6de06502b0
SHA1:           e3bcc45f033a67b6ed86a7aaadfdbb6de06502b0
Command:        find ARG -name ARG
Description:    Find by name
```

## Syncing
`pin` allows you to define your own sync method for your commands. I just use
another GitHub private repository. The way works is that whenever you
run `pin sync` command, `pin` executes `pin-sync.sh` script (found in this
repository) inside your commands directory. In order to setup sync, follow
these steps:

* Update `pin-sync.sh` with your custom commands to backup commands. If you want
  to use a `GitHub` based backup, setup another private repository in your
  account and clone it. Add following lines to `pin-sync.sh`:
  ``` bash
  git add .
  git commit -m "Automated commit message $(date)"
  git push
  ```
* Run `./pin install` inside `pin` rpeository to point pin to your new folder and to copy pin-sync.sh.
* Simply run `pin sync` to backup your commands.

# Contributing

Please submit feature requests [here](https://github.com/harshadjs/pin/issues).
Pull requests are welcome!
