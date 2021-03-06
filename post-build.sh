#!/bin/sh

set -e

# Create the revert script for manually switching back to the previously
# active firmware.
mkdir -p $TARGET_DIR/usr/share/fwup
$HOST_DIR/usr/bin/fwup -c -f $NERVES_DEFCONFIG_DIR/fwup-revert.conf -o $TARGET_DIR/usr/share/fwup/revert.fw

# Create the symlink to musl
ln -sf /usr/lib/libc.so $TARGET_DIR/lib/ld-musl-arm.so.1

# Copy the fwup includes to the images dir
cp -rf $NERVES_DEFCONFIG_DIR/fwup_include $BINARIES_DIR
