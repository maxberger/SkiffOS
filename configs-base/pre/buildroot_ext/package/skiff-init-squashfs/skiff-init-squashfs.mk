################################################################################
#
# skiff-init-squashfs
#
################################################################################

SKIFF_INIT_SQUASHFS_INSTALL_IMAGES = YES

SKIFF_INIT_SQUASHFS_INIT_PROC = $(call qstrip,$(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_INIT_PROC))
SKIFF_INIT_SQUASHFS_CFLAGS = $(TARGET_CFLAGS) -static \
	-DSKIFF_INIT_PROC='"$(SKIFF_INIT_SQUASHFS_INIT_PROC)"'

SKIFF_INIT_SQUASHFS_BIND_HOST_DIRS = $(call qstrip,$(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_BIND_HOST_DIRS))
ifneq ($(SKIFF_INIT_SQUASHFS_BIND_HOST_DIRS),)
SKIFF_INIT_SQUASHFS_CFLAGS += \
	-DBIND_HOST_DIRS='"$(SKIFF_INIT_SQUASHFS_BIND_HOST_DIRS)"'
endif

SKIFF_INIT_SQUASHFS_PATH = $(call qstrip,$(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_PATH))
ifneq ($(SKIFF_INIT_SQUASHFS_PATH),)
SKIFF_INIT_SQUASHFS_CFLAGS += \
	-DSKIFF_INIT_FILE='"$(SKIFF_INIT_SQUASHFS_PATH)"'
endif

SKIFF_INIT_SQUASHFS_WAIT_EXISTS = $(call qstrip,$(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_WAIT_EXISTS))
ifneq ($(SKIFF_INIT_SQUASHFS_WAIT_EXISTS),)
SKIFF_INIT_SQUASHFS_CFLAGS += \
	-DWAIT_EXISTS='"$(SKIFF_INIT_SQUASHFS_WAIT_EXISTS)"'
endif

SKIFF_INIT_SQUASHFS_MOUNT_BOOT = $(call qstrip,$(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_MOUNT_BOOT))
ifneq ($(SKIFF_INIT_SQUASHFS_MOUNT_BOOT),)
SKIFF_INIT_SQUASHFS_CFLAGS += \
	-DMOUNT_BOOT='"$(SKIFF_INIT_SQUASHFS_MOUNT_BOOT)"'
endif

ifeq ($(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_MOUNT_BOOT_BIND),y)
SKIFF_INIT_SQUASHFS_CFLAGS += -DMOUNT_BOOT_BIND
endif

SKIFF_INIT_SQUASHFS_MOUNT_BOOT_OPTS = $(call qstrip,$(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_MOUNT_BOOT_OPTS))
ifneq ($(SKIFF_INIT_SQUASHFS_MOUNT_BOOT_OPTS),)
SKIFF_INIT_SQUASHFS_CFLAGS += \
	-DMOUNT_BOOT_OPTS='"$(SKIFF_INIT_SQUASHFS_MOUNT_BOOT_OPTS)"'
endif

SKIFF_INIT_SQUASHFS_MOUNT_BOOT_FSTYPE = $(call qstrip,$(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_MOUNT_BOOT_FSTYPE))
ifneq ($(SKIFF_INIT_SQUASHFS_MOUNT_BOOT_FSTYPE),)
SKIFF_INIT_SQUASHFS_CFLAGS += \
	-DMOUNT_BOOT_FSTYPE='"$(SKIFF_INIT_SQUASHFS_MOUNT_BOOT_FSTYPE)"'
endif

SKIFF_INIT_SQUASHFS_MUTABLE_OVERLAY_SIZE = $(call qstrip,$(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_MUTABLE_OVERLAY_SIZE))
ifneq ($(SKIFF_INIT_SQUASHFS_MUTABLE_OVERLAY_SIZE),)
SKIFF_INIT_SQUASHFS_CFLAGS += \
	-DMUTABLE_OVERLAY_SIZE='"$(SKIFF_INIT_SQUASHFS_MUTABLE_OVERLAY_SIZE)"'
endif

ifeq ($(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_BIND_ROOT_MNT),y)
SKIFF_INIT_SQUASHFS_CFLAGS += -DBIND_ROOT_MNT
endif

ifneq ($(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_CHROOT_TARGET),y)
SKIFF_INIT_SQUASHFS_CFLAGS += -DNO_CHROOT_TARGET
endif

ifneq ($(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_MOUNT_PROC),y)
SKIFF_INIT_SQUASHFS_CFLAGS += -DNO_MOUNT_PROC
endif

ifneq ($(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_MOUNT_SYS),y)
SKIFF_INIT_SQUASHFS_CFLAGS += -DNO_MOUNT_SYS
endif

ifeq ($(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_MOUNT_SYS_RBIND),y)
SKIFF_INIT_SQUASHFS_CFLAGS += -DMOUNT_SYS_RBIND
endif

ifeq ($(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_NO_MOVE_MOUNTPOINT_ROOT),y)
SKIFF_INIT_SQUASHFS_CFLAGS += -DNO_MOVE_MOUNTPOINT_ROOT
endif

ifeq ($(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_ROOT_AS_BOOT),y)
SKIFF_INIT_SQUASHFS_CFLAGS += -DROOT_AS_BOOT
endif

ifeq ($(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_ROOT_AS_PERSIST),y)
SKIFF_INIT_SQUASHFS_CFLAGS += -DROOT_AS_PERSIST
endif

ifeq ($(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_ROOT_MAKE_SHARED),y)
SKIFF_INIT_SQUASHFS_CFLAGS += -DROOT_MAKE_SHARED
endif

ifeq ($(BR2_PACKAGE_SKIFF_INIT_SQUASHFS_WRITE_SKIFF_INIT_PID),y)
SKIFF_INIT_SQUASHFS_CFLAGS += -DWRITE_SKIFF_INIT_PID
endif

define SKIFF_INIT_SQUASHFS_BUILD_CMDS
	$(TARGET_CC) $(SKIFF_INIT_SQUASHFS_CFLAGS) -o $(@D)/skiff-init-squashfs \
		$(SKIFF_INIT_SQUASHFS_PKGDIR)/skiff-init-squashfs.c
	$(TARGET_STRIP) -s $(@D)/skiff-init-squashfs
endef

define SKIFF_INIT_SQUASHFS_INSTALL_IMAGES_CMDS
	mkdir -p $(BINARIES_DIR)/skiff-init
	$(INSTALL) -m 755 -D $(@D)/skiff-init-squashfs \
		$(BINARIES_DIR)/skiff-init/skiff-init-squashfs
endef

$(eval $(generic-package))
