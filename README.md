# Nginx Config Formatter
nginx config file formatter/beautifier written in Go. 
This is a port of the original formatter written in python here: [1connect/nginx-config-formatter](https://github.com/1connect/nginx-config-formatter)

![Go](https://github.com/nginx-config-formatter/nginx-config-formatter/workflows/Go/badge.svg)

This Go app script formats *nginx* configuration files in consistent way, described below:

* all lines are indented in uniform manner, with 4 spaces per level
* neighbouring empty lines are collapsed to at most two empty lines
* curly braces placement follows Java convention
* whitespaces are collapsed, except in comments an quotation marks
* whitespaces in variable designators are removed: `${  my_variable }` is collapsed to `${my_variable}`

## Installation

Go get to run this app:

    go get github.com/gnagel/nginx-config-formatter
    go tool github.com/gnagel/nginx-config-formatter ...  


## Usage

```
Usage:
  nginx-config-formatter [command]

Available Commands:
  fmt         Nginx config file formatter
  help        Help about any command

Flags:
      --config string   config file (default is $HOME/.nginx-config-formatter.yaml)
  -h, --help            help for nginx-config-formatter
  -t, --toggle          Help message for toggle

Use "nginx-config-formatter [command] --help" for more information about a command.
```

## Credits

Copyright 2020 G. Nagel, credit for original inspiration goes to Michał Słomkowski.