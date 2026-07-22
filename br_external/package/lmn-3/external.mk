################################################################################
#
# LMN-3
#
################################################################################

LMN_3_VERSION = 1.0
LMN_3_SITE = ""
LMN_3_SITE_METHOD = local

define LMN_3_INSTALL_INIT_SYSV
    $(INSTALL) -D -m 0755 $(LMN_3_PKGDIR)/S60xterm \
    $(TARGET_DIR)/etc/init.d/S60xterm
endef

$(eval $(generic-package))