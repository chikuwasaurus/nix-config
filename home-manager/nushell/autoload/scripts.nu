# Project picker helpers.
#
# p-select is a shared external script that only prints a selected project path.
# These functions are shell-specific because `cd` must affect the current
# interactive shell, so they must use `def --env`.
def --env p-open [
  editor: string # Editor command name: zed or nvim
  dev_dir?: path # Optional base directory that contains projects
] {
  let project = if ($dev_dir | is-empty) {
    p-select
  } else {
    p-select $dev_dir
  }

  if ($project | is-empty) {
    return
  }

  cd $project

  match $editor {
    "zed" => {
      if (which zed | is-empty) {
        print --stderr "zed is not found"
        return
      }

      zed $project
    }

    "nvim" => {
      if (which nvim | is-empty) {
        print --stderr "nvim is not found"
        return
      }

      nvim $project
    }

    _ => {
      print --stderr $"unknown editor: ($editor)"
    }
  }
}

def --env zp [
  dev_dir?: path # Optional base directory that contains projects
] {
  if ($dev_dir | is-empty) {
    p-open zed
  } else {
    p-open zed $dev_dir
  }
}

def --env np [
  dev_dir?: path # Optional base directory that contains projects
] {
  if ($dev_dir | is-empty) {
    p-open nvim
  } else {
    p-open nvim $dev_dir
  }
}
