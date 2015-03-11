# Inherit common stuff
$(call inherit-product, vendor/infamous/config/common.mk)

# Ringtones
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.ringtone=Callisto.ogg \
    ro.config.notification_sound=Tethys.ogg \
    ro.config.alarm_alert=Helium.ogg

$(call inherit-product, vendor/infamous/config/common_apn.mk)

# SIM Toolkit
PRODUCT_PACKAGES += \
    Stk