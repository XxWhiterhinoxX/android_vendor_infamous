# Inherit common infamous stuff
$(call inherit-product, vendor/infamous/config/common.mk)

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Hassium.ogg

# media
ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_BOOTANIMATION := vendor/infamous/prebuilt/common/bootanimation/1280.zip:system/media/bootanimation.zip
endif
