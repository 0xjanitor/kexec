#!/bin/sh

# kboot - 'root=/dev/mapper/vg00-lv_root ro crashkernel=auto rd.lvm.lv=vg00/lv_root rd.lvm.lv=vg00/lv_swap console=ttyS0,115200 systemd.log_level=debug'

[[ "$1" != '-' ]] && kernel="$1"
shift
if [[ "$1" == '-' ]]; then
    reuse=--reuse-cmdline
    shift
fi
[[ $# == 0 ]] && reuse=--reuse-cmdline
kernel="${kernel:-$(uname -r)}"
kargs="/boot/vmlinuz-$kernel --initrd=/boot/initramfs-$kernel.img"

kexec -l -t bzImage $kargs $reuse --append="$*" && \
    systemctl kexec
