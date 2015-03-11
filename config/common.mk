PRODUCT_BRAND ?= Infamous

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/infamous/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_BOOTANIMATION := vendor/infamous/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip
else
PRODUCT_BOOTANIMATION := vendor/infamous/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1 \
    persist.sys.root_access=3

# Tether for all
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/infamous/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/infamous/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/infamous/prebuilt/common/bin/50-infamous.sh:system/addon.d/50-infamous.sh \
    vendor/infamous/prebuilt/common/bin/blacklist:system/addon.d/blacklist

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/infamous/prebuilt/common/bin/otasigcheck.sh:system/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/infamous/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/infamous/prebuilt/common/bin/sysinit:system/bin/sysinit

# userinit support
PRODUCT_COPY_FILES += \
    vendor/infamous/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# SuperSU
PRODUCT_COPY_FILES += \
    vendor/infamous/prebuilt/common/etc/UPDATE-SuperSU.zip:system/addon.d/UPDATE-SuperSU.zip \
    vendor/infamous/prebuilt/common/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon

# infamous-specific init file
PRODUCT_COPY_FILES += \
    vendor/infamous/prebuilt/common/etc/init.cm.rc:root/init.cm.rc \

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/infamous/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/infamous/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# T-Mobile theme engine
include vendor/infamous/config/themes_common.mk

# infamous Stuff
PRODUCT_PACKAGES += \
    PerformanceControl \
    SlimLauncher \
    Eleven \
    DashClock \
    DeskClock \
    LockClock

# Misc packages
PRODUCT_PACKAGES += \
    libemoji \
    SpareParts \
    LiveWallpapersPicker \
    vim \
    Development \
    LatinIME \
    BluetoothExt \
    Terminal

# Proprietary latinime lib needed for Keyboard swyping
PRODUCT_COPY_FILES += \
    vendor/infamous/prebuilt/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so
    
# Infamous themes
PRODUCT_COPY_FILES += \
    vendor/infamous/prebuilt/common/etc/infamous_theme.apk:system/app/Infamous_Theme/infamous_theme.apk \
    vendor/infamous/prebuilt/common/etc/infamous_teal.apk:system/app/Infamous_Teal/infamous_teal.apk

# Viper4Android
PRODUCT_COPY_FILES += \
    vendor/infamous/prebuilt/common/app/ViPER4Android/ViPER4Android.apk:system/app/ViPER4Android/ViPER4Android.apk

# Bring in all video files
$(call inherit-product, frameworks/base/data/videos/VideoPackage2.mk)

# Include infamous audio files
include vendor/infamous/config/infamous_audio.mk

# Include infamous LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/infamous/overlay/dictionaries

# CM Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra tools in infamous
PRODUCT_PACKAGES += \
    libsepol \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
    nano \
    htop \
    powertop \
    lsof \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    mkfs.f2fs \
    fsck.f2fs \
    fibmap.f2fs \
    ntfsfix \
    ntfs-3g \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libstagefright_soft_ffmpegadec \
    libstagefright_soft_ffmpegvdec \
    libFFmpegExtractor \
    libnamparser

PRODUCT_PACKAGE_OVERLAYS += vendor/infamous/overlay/common

# version
RELEASE = false
INFAMOUS_VERSION_MAJOR = 2
INFAMOUS_VERSION_MINOR = 0

# release
ifeq ($(RELEASE),true)
    INFAMOUS_VERSION := INFAMOUS-LP-MileStone-$(INFAMOUS_VERSION_MAJOR).$(INFAMOUS_VERSION_MINOR)
else
    INFAMOUS_VERSION_STATE := $(shell date +%Y-%m-%d)
    INFAMOUS_VERSION := INFAMOUS-LP-v$(INFAMOUS_VERSION_MAJOR).$(INFAMOUS_VERSION_MINOR)-$(INFAMOUS_VERSION_STATE)
endif

# HFM Files
PRODUCT_COPY_FILES += \
	vendor/infamous/prebuilt/etc/hosts.alt:system/etc/hosts.alt \
	vendor/infamous/prebuilt/etc/hosts.og:system/etc/hosts.og

PRODUCT_PROPERTY_OVERRIDES += \
    ro.infamous.version=$(INFAMOUS_VERSION)

ifeq ($(RELEASE),true)
# Disable multithreaded dexopt by default
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.dalvik.multithread=false
endif

# Chromium Prebuilt
ifeq ($(PRODUCT_PREBUILT_WEBVIEWCHROMIUM),yes)
-include prebuilts/chromium/$(TARGET_DEVICE)/chromium_prebuilt.mk
endif

# by default, do not update the recovery with system updates
PRODUCT_PROPERTY_OVERRIDES += persist.sys.recovery_update=false

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

$(call inherit-product-if-exists, vendor/extra/product.mk)
