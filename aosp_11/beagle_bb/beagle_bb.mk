

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)


PRODUCT_NAME := beagle_bb
PRODUCT_DEVICE := beagle_bb
PRODUCT_BRAND := Android
PRODUCT_MODEL := AOSP on BeagleBoard Bone Black
PRODUCT_MANUFACTURER := Texas Instruments Inc

PRODUCT_PLATFORM=bb
PRODUCT_HARDWARE=bb


PRODUCT_COPY_FILES += \
	frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
	frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    device/ti/beagle_bb/fstab.bb:$(TARGET_COPY_OUT_RAMDISK)/fstab.$(PRODUCT_PLATFORM) \
	device/ti/beagle_bb/fstab.bb:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.$(PRODUCT_PLATFORM) \
	device/ti/beagle_bb/init.bb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.bb.rc

	