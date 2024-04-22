OVERVIEW

Android kernel needs to be compiled for Beaglebone along with some changes to device tree source of Beaglebone to include the first stage init mounting of partitions.


STEPS TO COMPILE ANDROID COMMON KERNEL_11.5.4 

1. We need to create a config file specifying the build config for Beaglebone in the "common" folder.

2. Checkout the file build.config.beagle32 and place in the common folder.

3. To avoid circular dependency kernel build failure, set the CONFIG_USB_CONFIGFS=n in omap2plus_defconfig present in <kernel_src>/common/arch/arm/configs/omap2plus_defconfig. Sample omap2plus_defconfig attached for reference.

4. To mount the partitions early during boot, device tree of beaglebone needs to be modified with mentioning the partitions to mount early. 

5. am335x-boneblack.dts  has be updated with the system, vendor and data partitions.Checkout the file and replace with the one present in 
    <kernel_src>/common/arch/arm/boot/dts/am335x-boneblack.dts.


Please note that we are concatenating the google's gki_defconfig and Beaglebone's omap2plus_defconfig to achieve the required kernel configuration for android.

Compile kernel from the kernel source rootdir with the below command

		BUILD_CONFIG=common/build.config.beagle32  build/build.sh 

Once the build is successful in build logs the zImage and dtb file location will be listed.

Artefacts are generally generated in 

1. zImage in <kernel_rootdir>/out/common_<kernel-ver>/arch/arm/boot/

2. am335x_beaglebone.dts in <kernel_rootdir>/out/common_<kernel-ver>/arch/arm/boot/dts/.

Keep these 2 handly will be used in booting the beaglebone.



