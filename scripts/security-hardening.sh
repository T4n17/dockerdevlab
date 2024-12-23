#!/bin/bash
set -e

echo "Starting security hardening process..."

# Backup current configurations if they exist
backup_dir="docker/config/backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"

echo "Creating backup of current configurations..."

# Backup daemon.json if it exists
if [ -f "/etc/docker/daemon.json" ]; then
    echo "Backing up daemon.json..."
    sudo cp "/etc/docker/daemon.json" "$backup_dir/daemon.json.bak"
fi

# Backup seccomp profile if it exists
if [ -f "/etc/docker/seccomp-profile.json" ]; then
    echo "Backing up seccomp profile..."
    sudo cp "/etc/docker/seccomp-profile.json" "$backup_dir/seccomp-profile.json.bak"
fi

# Backup audit rules if they exist
if [ -f "/etc/audit/rules.d/docker.rules" ]; then
    echo "Backing up audit rules..."
    sudo cp "/etc/audit/rules.d/docker.rules" "$backup_dir/docker.rules.bak"
fi

# Create necessary directories
mkdir -p ssh workspace docker/config

# Set proper permissions
chmod 700 ssh
chmod 755 workspace
chmod 700 scripts/*.sh

# Ensure .env is secured if it exists
if [ -f .env ]; then
    chmod 600 .env
fi

# Create Docker daemon security configuration
cat > docker/config/daemon.json << EOF
{
    "icc": false,
    "no-new-privileges": false,
    "default-ulimits": {
        "nofile": {
            "Name": "nofile",
            "Hard": 64000,
            "Soft": 64000
        }
    },
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    },
    "live-restore": true,
    "userland-proxy": false,
    "seccomp-profile": "/etc/docker/seccomp-profile.json"
}
EOF

# Create custom seccomp profile
cat > docker/config/seccomp-profile.json << EOF
{
    "defaultAction": "SCMP_ACT_ERRNO",
    "architectures": [
        "SCMP_ARCH_X86_64",
        "SCMP_ARCH_X86",
        "SCMP_ARCH_AARCH64"
    ],
    "syscalls": [
        {
            "names": [
                "accept",
                "accept4",
                "access",
                "acct",
                "add_key",
                "adjtimex",
                "alarm",
                "arch_prctl",
                "bind",
                "bpf",
                "brk",
                "capget",
                "capset",
                "chdir",
                "chmod",
                "chown",
                "chroot",
                "clock_adjtime",
                "clock_getres",
                "clock_gettime",
                "clock_nanosleep",
                "clone",
                "clone3",
                "close",
                "connect",
                "copy_file_range",
                "creat",
                "dup",
                "dup2",
                "dup3",
                "epoll_create",
                "epoll_create1",
                "epoll_ctl",
                "epoll_ctl_old",
                "epoll_pwait",
                "epoll_wait",
                "epoll_wait_old",
                "eventfd",
                "eventfd2",
                "execve",
                "execveat",
                "exit",
                "exit_group",
                "faccessat",
                "faccessat2",
                "fadvise64",
                "fallocate",
                "fanotify_init",
                "fanotify_mark",
                "fchdir",
                "fchmod",
                "fchmodat",
                "fchown",
                "fchownat",
                "fcntl",
                "fdatasync",
                "fgetxattr",
                "flistxattr",
                "flock",
                "fork",
                "fremovexattr",
                "fsetxattr",
                "fstat",
                "fstatfs",
                "fsync",
                "ftruncate",
                "futex",
                "futimesat",
                "get_mempolicy",
                "get_robust_list",
                "get_thread_area",
                "getcpu",
                "getcwd",
                "getdents",
                "getdents64",
                "getegid",
                "geteuid",
                "getgid",
                "getgroups",
                "getitimer",
                "getpeername",
                "getpgid",
                "getpgrp",
                "getpid",
                "getppid",
                "getpriority",
                "getrandom",
                "getresgid",
                "getresuid",
                "getrlimit",
                "getrusage",
                "getsid",
                "getsockname",
                "getsockopt",
                "gettid",
                "gettimeofday",
                "getuid",
                "getxattr",
                "init_module",
                "inotify_add_watch",
                "inotify_init",
                "inotify_init1",
                "inotify_rm_watch",
                "io_cancel",
                "io_destroy",
                "io_getevents",
                "io_setup",
                "io_submit",
                "ioctl",
                "ioprio_get",
                "ioprio_set",
                "ipc",
                "kill",
                "lchown",
                "lgetxattr",
                "link",
                "linkat",
                "listen",
                "listxattr",
                "llistxattr",
                "lremovexattr",
                "lseek",
                "lsetxattr",
                "lstat",
                "madvise",
                "mbind",
                "membarrier",
                "memfd_create",
                "migrate_pages",
                "mincore",
                "mkdir",
                "mkdirat",
                "mknod",
                "mknodat",
                "mlock",
                "mlock2",
                "mlockall",
                "mmap",
                "mount",
                "move_pages",
                "mprotect",
                "mq_getsetattr",
                "mq_notify",
                "mq_open",
                "mq_timedreceive",
                "mq_timedsend",
                "mq_unlink",
                "mremap",
                "msgctl",
                "msgget",
                "msgrcv",
                "msgsnd",
                "msync",
                "munlock",
                "munlockall",
                "munmap",
                "name_to_handle_at",
                "nanosleep",
                "newfstatat",
                "open",
                "open_by_handle_at",
                "openat",
                "pause",
                "perf_event_open",
                "personality",
                "pipe",
                "pipe2",
                "pivot_root",
                "pkey_alloc",
                "pkey_free",
                "pkey_mprotect",
                "poll",
                "ppoll",
                "prctl",
                "pread64",
                "preadv",
                "preadv2",
                "prlimit64",
                "process_vm_readv",
                "process_vm_writev",
                "pselect6",
                "ptrace",
                "pwrite64",
                "pwritev",
                "pwritev2",
                "read",
                "readahead",
                "readlink",
                "readlinkat",
                "readv",
                "reboot",
                "recv",
                "recvfrom",
                "recvmmsg",
                "recvmsg",
                "remap_file_pages",
                "removexattr",
                "rename",
                "renameat",
                "renameat2",
                "request_key",
                "restart_syscall",
                "rmdir",
                "rseq",
                "rt_sigaction",
                "rt_sigpending",
                "rt_sigprocmask",
                "rt_sigqueueinfo",
                "rt_sigreturn",
                "rt_sigsuspend",
                "rt_sigtimedwait",
                "rt_tgsigqueueinfo",
                "sched_get_priority_max",
                "sched_get_priority_min",
                "sched_getaffinity",
                "sched_getattr",
                "sched_getparam",
                "sched_getscheduler",
                "sched_rr_get_interval",
                "sched_setaffinity",
                "sched_setattr",
                "sched_setparam",
                "sched_setscheduler",
                "sched_yield",
                "seccomp",
                "select",
                "semctl",
                "semget",
                "semop",
                "semtimedop",
                "send",
                "sendfile",
                "sendmmsg",
                "sendmsg",
                "sendto",
                "set_mempolicy",
                "set_robust_list",
                "set_thread_area",
                "set_tid_address",
                "setdomainname",
                "setfsgid",
                "setfsuid",
                "setgid",
                "setgroups",
                "sethostname",
                "setitimer",
                "setns",
                "setpgid",
                "setpriority",
                "setregid",
                "setresgid",
                "setresuid",
                "setreuid",
                "setrlimit",
                "setsid",
                "setsockopt",
                "setuid",
                "setxattr",
                "shmat",
                "shmctl",
                "shmdt",
                "shmget",
                "shutdown",
                "sigaltstack",
                "signalfd",
                "signalfd4",
                "socket",
                "socketpair",
                "splice",
                "stat",
                "statfs",
                "statx",
                "swapoff",
                "swapon",
                "symlink",
                "symlinkat",
                "sync",
                "sync_file_range",
                "syncfs",
                "sysinfo",
                "syslog",
                "tee",
                "tgkill",
                "time",
                "timer_create",
                "timer_delete",
                "timer_getoverrun",
                "timer_gettime",
                "timer_settime",
                "timerfd_create",
                "timerfd_gettime",
                "timerfd_settime",
                "times",
                "tkill",
                "truncate",
                "umask",
                "umount2",
                "uname",
                "unlink",
                "unlinkat",
                "unshare",
                "userfaultfd",
                "ustat",
                "utime",
                "utimensat",
                "utimes",
                "vfork",
                "vmsplice",
                "wait4",
                "waitid",
                "write",
                "writev"
            ],
            "action": "SCMP_ACT_ALLOW"
        }
    ]
}
EOF

# Create audit rules for Docker
cat > docker/config/audit.rules << EOF
-w /usr/bin/docker -k docker
-w /var/lib/docker -k docker
-w /etc/docker -k docker
-w /docker/config/daemon.json -k docker
-w /docker/config/seccomp-profile.json -k docker
-w /etc/default/docker -k docker
-w /etc/docker/daemon.json -k docker
-w /usr/lib/systemd/system/docker.service -k docker
EOF

echo "Security configurations have been generated."
echo ""
echo "Applying security configurations..."
echo ""
echo "1. Copying daemon.json to /etc/docker/daemon.json"

sudo cp docker/config/daemon.json /etc/docker/daemon.json

echo ""
echo "2. Copying seccomp profile"

sudo cp docker/config/seccomp-profile.json /etc/docker/seccomp-profile.json

echo ""
echo "3. Copying audit rules"

sudo cp docker/config/audit.rules /etc/audit/rules.d/docker.rules

echo ""
echo "4. Restarting Docker daemon"

sudo systemctl restart docker

echo ""
echo "5. Verify configurations with these commands:"
echo "   docker info | grep -i seccomp"
echo "   docker info | grep -i cgroup"
echo ""
echo "Security hardening completed."
