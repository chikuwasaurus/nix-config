# config.nu
#
# Installed by:
# version = "0.112.2"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings,
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

$env.config.buffer_editor = "hx"
$env.config.show_banner = false
$env.config.highlight_resolved_externals = true

# Homebrew setup.
# if ('/opt/homebrew' | path type) == 'dir' {
#     $env.HOMEBREW_PREFIX = '/opt/homebrew'
#     $env.HOMEBREW_CELLAR = '/opt/homebrew/Cellar'
#     $env.HOMEBREW_REPOSITORY = '/opt/homebrew'
#     $env.PATH = $env.PATH? | prepend [
#         '/opt/homebrew/bin'
#         '/opt/homebrew/sbin'
#     ]
#     $env.MANPATH = $env.MANPATH? | prepend '/opt/homebrew/share/man'
#     $env.INFOPATH = $env.INFOPATH? | prepend '/opt/homebrew/share/info'
# }

do {
    # Create user-autoload-dir for startup files.
    const user_autoload_dir: string = ($nu.default-config-dir | path join autoload)
    mkdir $user_autoload_dir

    # Starship setup.
    # const starship_config_file: string = ($user_autoload_dir | path join starship.nu)
    # if not ($starship_config_file | path exists) {
    #     starship init nu | save $starship_config_file
    # }

    # Zoxide setup.
    const zoxide_config_file: string = ($user_autoload_dir | path join zoxide.nu)
    if not ($zoxide_config_file | path exists) {
        zoxide init nushell | save $zoxide_config_file
    }

    # Atuin setup.
    # const atuin_config_file: string = ($user_autoload_dir | path join atuin.nu)
    # if not ($atuin_config_file | path exists) {
    #     atuin init nu | save $atuin_config_file
    # }

    # mise setup.
    # const mise_config_file: string = ($user_autoload_dir | path join mise.nu)
    # if not ($mise_config_file | path exists) {
    #     mise activate nu | save $mise_config_file
    # }
}

# Completers
# https://www.nushell.sh/cookbook/external_completers.html
let fish_completer = {|spans|
    fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {|row|
      let value = $row.value
      let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
      if ($need_quote and ($value | path exists)) {
        let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
        $'"($expanded_path | str replace --all "\"" "\\\"")"'
      } else {$value}
    }
}

let carapace_completer = {|spans: list<string>|
    CARAPACE_LENIENT=1 carapace $spans.0 nushell ...$spans | from json
}

# This completer will use carapace by default
let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -o 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        # carapace completions are incorrect for nu
        # nu => $fish_completer
        # fish completes commits and branch names in a nicer way
        # git => $fish_completer
        _ => $carapace_completer
    } | do $in $spans
}

$env.config = {
    completions: {
        external: {
            enable: true
            completer: $external_completer
        }
    }
}
