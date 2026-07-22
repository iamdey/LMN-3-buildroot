################################################################################
#
# lmn-3
#
################################################################################

LMN-3_VERSION = 1.0
LMN-3_SITE = $(BR2_EXTERNAL_MONDEPOT_PATH)/package/lmn-3/src
LMN-3_SITE_METHOD = local

define LMN-3_BUILD_CMDS
    # $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D)
endef

define LMN-3_INSTALL_TARGET_CMDS
    # $(INSTALL) -D -m 0755 $(@D)/lmn-3 $(TARGET_DIR)/usr/bin
endef

define LMN-3_INSTALL_INIT_SYSV
    $(INSTALL) -D -m 0755 $(LMN-3_PKGDIR)/S99xterm \
    $(TARGET_DIR)/etc/init.d/S99xterm
endef

$(eval $(generic-package))