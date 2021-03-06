#!/bin/bash
# From https://github.com/antygravity/docker/blob/master/android-x86-java8/tools/kvm-mknod.sh
# If possible, create the /dev/kvm device node.

set -e

lsmod | grep '\<kvm\>' > /dev/null || {
  echo >&2 "KVM module not loaded; software emulation will be used"
  exit 0
}

mknod /dev/kvm c 10 $(grep '\<kvm\>' /proc/misc | cut -f 1 -d' ') || {
  echo >&2 "Unable to make /dev/kvm node; software emulation will be used"
  echo >&2 "(This can happen if the container is run without -privileged)"
  exit 0
}

dd if=/dev/kvm count=0 2>/dev/null || {
  echo >&2 "Unable to open /dev/kvm; qemu will use software emulation"
  echo >&2 "(This can happen if the container is run without -privileged)"
}

# authorize the kvm group to use KVM
chown root:kvm /dev/kvm
chmod g+w /dev/kvm
