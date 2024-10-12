set -l commands bootstrap clone cmd config console convert cp create destroy edit export help htop import limits list mount pkg rcp rdr rename restart service setup start stop sysrc tags template top umount update upgrade verify zfs

complete -c bastille -f
complete -c bastille -e


complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "bootstrap" -d 'Bootstrap a FreeBSD release for container base.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "clone" -d 'Clone an existing container.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "cmd" -d 'Execute arbitrary command on targeted container(s).'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "config" -d 'Get or set a config value for the targeted container(s).'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "console" -d 'Console into a running container.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "convert" -d 'Convert a Thin container into a Thick container.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "cp" -d 'cp(1) files from host to targeted container(s).'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "create" -d 'Create a new thin container or a thick container if -T|--thick option specified.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "destroy" -d 'Destroy a stopped container or a FreeBSD release.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "edit" -d 'Edit container configuration files (advanced).'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "export" -d 'Exports a specified container.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "help" -d 'Help about any command.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "htop" -d 'Interactive process viewer (requires htop).'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "import" -d 'Import a specified container.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "limits" -d 'Apply resources limits to targeted container(s). See rctl(8).'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "list" -d 'List containers (running and stopped).'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "mount" -d 'Mount a volume inside the targeted container(s).'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "pkg" -d 'Manipulate binary packages within targeted container(s). See pkg(8).'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "rcp" -d 'reverse cp(1) files from a single container to the host.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "rdr" -d 'Redirect host port to container port.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "rename" -d 'Rename a container.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "restart" -d 'Restart a running container.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "service" -d 'Manage services within targeted container(s).'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "setup" -d 'Attempt to auto-configure network, firewall and storage on new installs.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "start" -d 'Start a stopped container.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "stop" -d 'Stop a running container.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "sysrc" -d 'Safely edit rc files within targeted container(s).'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "tags" -d 'Add or remove tags to targeted container(s).'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "template" -d 'Apply file templates to targeted container(s).'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "top" -d 'Display and update information about the top(1) cpu processes.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "umount" -d 'Unmount a volume from within the targeted container(s).'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "update" -d 'Update container base -pX release.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "upgrade" -d 'Upgrade container release to X.Y-RELEASE.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "verify" -d 'Compare release against a "known good" index.'
complete -c bastille -n "not __fish_seen_subcommand_from $commands" \
    -a "zfs" -d 'Manage (get|set) ZFS attributes on targeted container(s).'

# set -l jails (sudo bastille list jail)

complete -c bastille -n "not __fish_seen_subcommand_from export import list" \
    -n 'test (count (commandline -opc)) -eq 2' \
    -a "(sudo bastille list jail)"

function compledit
    set -l args (commandline -opc)
    if test (count $args) -eq 3
        set jail $args[-1]
        # echo (commandline -t) >&2
        set basepath /usr/local/bastille/jails/$jail/
        set curpath $basepath(commandline -t)
        set -l subdirs (sudo fish -c "__fish_complete_path $curpath")
        # sudo fish -c "__fish_complete_path $curpath"
        echo -e (string join '\n' (string replace -a $basepath '' $subdirs))
    end
    # if test count $args -gt 
end

complete -c bastille -n "__fish_seen_subcommand_from edit" -a "(compledit)"
