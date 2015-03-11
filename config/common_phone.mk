# Inherit common infamous stuff
$(call inherit-product, vendor/infamous/config/common.mk)

# ringtones
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.ringtone=Callisto.ogg \
    ro.config.notification_sound=Tethys.ogg \
    ro.config.alarm_alert=Helium.ogg

# media
ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_BOOTANIMATION := vendor/infamous/prebuilt/common/bootanimation/720.zip:system/media/bootanimation.zip
endif

$(call inherit-product, vendor/infamous/config/telephony.mk)
