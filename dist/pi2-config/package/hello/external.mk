################################################################################
#
# hello
#
################################################################################

HELLO_VERSION = 1.0
HELLO_SITE = $(BR2_EXTERNAL_PI2_CONFIG_PATH)/package/hello/src
HELLO_SITE_METHOD = local

define HELLO_BUILD_CMDS
    $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D)
endef

define HELLO_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/hello $(TARGET_DIR)/usr/bin
endef

define HELLO_INSTALL_INIT_SYSV
    $(INSTALL) -D -m 0755 $(HELLO_PKGDIR)/S59hello \
    $(TARGET_DIR)/etc/init.d/S59hello
endef

$(eval $(generic-package))