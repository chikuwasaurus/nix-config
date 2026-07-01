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
    const starship_config_file: string = ($user_autoload_dir | path join starship.nu)
    if not ($starship_config_file | path exists) {
        starship init nu | save $starship_config_file
    }

    # Zoxide setup.
    const zoxide_config_file: string = ($user_autoload_dir | path join zoxide.nu)
    if not ($zoxide_config_file | path exists) {
        zoxide init nushell | save $zoxide_config_file
    }

    # Atuin setup.
    const atuin_config_file: string = ($user_autoload_dir | path join atuin.nu)
    if not ($atuin_config_file | path exists) {
        atuin init nu | save $atuin_config_file
    }

    # mise setup.
    # const mise_config_file: string = ($user_autoload_dir | path join mise.nu)
    # if not ($mise_config_file | path exists) {
    #     mise activate nu | save $mise_config_file
    # }
}
