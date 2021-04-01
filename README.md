<img src="https://cdn.rawgit.com/oh-my-fish/oh-my-fish/e4f1c2e0219a17e2c748b824004c8d0b38055c16/docs/logo.svg" align="left" width="144px" height="144px"/>

# `error`
> A simple, light-weight, user-friendly error message handler/printer.

[![MIT License](https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square)](LICENSE)
[![Fish Shell Version](https://img.shields.io/badge/fish-v3.0.0-007EC7.svg?style=flat-square)][fish]
[![Oh My Fish Framework](https://img.shields.io/badge/Oh%20My%20Fish-Framework-007EC7.svg?style=flat-square)][omf]

<br/>

## Installation
```fish
omf install error
```

## Usage
```fish
error [code] [message] [value...]
```
| Parameter       | Description                                               |
| --------------- | --------------------------------------------------------- |
| `code`          | The error code of the error that occured. See [Unix Error Codes](https://mazack.org/unix/errno.php).
| `message`       | The error message that should be printed to `stderr`.
| `value`         | The value that caused the error, such as an invalid parameter, or a filename.

If `code` is 0, `error` will not print anything and will return 0.
This is because an error code of 0 is considered to be success.
See [Remark 1](#r1).

### Examples
#### E1
```fish
touch file.txt
error $status 'File could not be created.' file.txt
```
Output (on failure of `touch`):
```
error: File could not be created.
Specifically: file.txt
```
#### E2
```fish
return (error 22 'Invalid parameter.' $param)
```
See [Remark 2](#r2).
#### E3
```fish
argparse 'i/input' -- $argv
if test $_flag_input -lt 0
    error 34 'Argument needs to be at least 0.' $_flag_input
end
```
Equivalent to:
```fish
argparse 'i/input' -- $argv
test $_flag_input -lt 0
error $status 'Argument needs to be at least 0.' $_flag_input
```

## Remarks
### R1
There is currently no way to force `error` to print anything when `code` is `0`.
If there is demand for such an option, I'm happy to implement it, but for now,
leaving it out improves brevity and performance of the code.

### R2
Due to a bug in fish ([#1035][fish-bug]), `stderr` output from within
parentheses (command substitution) cannot be redirected and is always printed
to the terminal. To avoid this, use this paradigm instead:
```fish
error 22 'Invalid parameter.' $param
return $status
```
When this bug gets fixed, the shortened syntax can also be used:
```fish
return (error 22 'Invalid parameter.' $param)
```
Using the shortened syntax is discouraged as of now, because the output of
`error` cannot be redirected or muted, resulting in an unpleasent experience.

### R3
`error` detects whether it is used inside of parentheses (command substitution).
If it is, it will print the error code to `stdout`,
so that the parentheses will be replaced with the code.

# License
[MIT][mit] © [Micha-ohne-el][author] et [al][contributors]


[mit]:            https://opensource.org/licenses/MIT
[author]:         https://github.com/Micha-ohne-el
[contributors]:   https://github.com/Micha-ohne-el/error/graphs/contributors
[fish]:           https://fishshell.com
[omf]:            https://github.com/oh-my-fish/oh-my-fish#readme
[fish-bug]:       https://github.com/fish-shell/fish-shell/issues/1035
