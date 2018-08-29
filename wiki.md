VIM Keyboard Examples
---------------------

* NOTE: A `<space>` between the Key Sequence means you hit both of those keys at the same time.

| Key Sequence | Description                                   |
|--------------|-----------------------------------------------|
| `g *`         | Highlight all occurrences in the current file |
| `g d`         | Goto local declaration from current pointer   |
| `g D`         | Goto global declaration for the current file  |

## Split Navigation

| Key Sequence | Description                                   |
| `ctrl w |`   | Create a vertical split                       |
| `ctrl w -`   | Create a horizontal split                     |

## VIM splits

* In order for this to work you need to install `ctags` and then run `ctags -R .` in your project directory.

| Key Sequence | Description                                   |
|--------------|-----------------------------------------------|
| `ctrl ]`     | Jump to definition from the current pointer   |
| `ctrl t`     | Jump back to the previous definition          |
| `g ]`        | Ask use which defintion to jump to in a pane  |
| `ctrl h`     | If left pane exists, switch to it             |
| `ctrl l`     | If right pane exists, switch to it            |
| `ctrl j`     | If below pane exists, switch to it            |
| `ctrl k`     | If above pane exists, switch to it            |
