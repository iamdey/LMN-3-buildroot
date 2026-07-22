################################################################################
#
# LMN-3
#
################################################################################

LMN_3_VERSION = 0.6.0
LMN_3_SITE = https://github.com/iamdey/LMN-3-DAW/releases/download/v${LMN_3_VERSION}
LMN_3_SOURCE = LMN-3-${LMN_3_ARCH}.zip
LMN_3_METHOD = site

# Determine the architecture target

ifeq ($(BR2_ARCH), "aarch64")
    LMN_3_ARCH=aarch64-linux-gnu
endif

ifeq ($(BR2_ARCH), "arm")
    LMN_3_ARCH=arm-linux-gnueabihf
endif

ifeq ($(BR2_ARCH), "x86_64")
    LMN_3_ARCH=x86_64
endif

# by default tar is used
define LMN_3_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(LMN_3_DL_DIR)/$(LMN_3_SOURCE)
endef

# Define the installation process
define LMN_3_INSTALL_TARGET_CMDS
    $(info Installing LMN-3 $(LMN_3_VERSION) for $(LMN_3_ARCH))

    # Copy the pre-compiled binary from the working directory to the target
    $(INSTALL) -D -m 0755 $(@D)/LMN-3 $(TARGET_DIR)/bin/LMN-3
endef

define LMN_3_INSTALL_INIT_SYSV
    $(info Configure LMN-3 to start on boot)
    $(INSTALL) -D -m 0755 $(LMN_3_PKGDIR)/S60lmn-3 \
    $(TARGET_DIR)/etc/init.d/S60lmn-3
endef

$(eval $(generic-package))