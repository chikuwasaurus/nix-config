def zd [
  dir?: path
] {
    let dev_dir = if ($dir == null) {
        $"($env.HOME)/Developer"
    } else {
        $dir | path expand
    }

    with-env { DEV_DIR: $dev_dir } {
        zed-project.sh
    }
}
