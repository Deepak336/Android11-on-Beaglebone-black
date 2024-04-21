# Android-11-on-Beaglebone-black
Android 11 on Beaglebone black

This is an effort to port aosp 11 on beaglebone black rev c to the extent possible,
given the limitations of the board.

The kernel used is Android common Kernel (ACK) android11-5.4 tag.

The AOSP tag used is android-11.0.0_r4.

Build machine: Ubuntu Jammy 22.04

Arch : x86-64


**DOWNLOADING THE SOURCES**

1. Prerequisite is to have repo installed.

   For installation instructions : https://source.android.com/setup/build/downloading#installing-repo
   
4. Create the directory and download ACK.

         mkdir android_kernel_11.5.4
     
         cd android_kernel_11.5.4

         repo init -u https://android.googlesource.com/kernel/manifest -b common-android11-5.4

         repo sync -j32 --optimized-fetch --current-branch --no-tags

7. Create the directory and download aosp android-11.0.0_r4 tag.

         mkdir aosp_11
   
         repo init -u https://android.googlesource.com/platform/manifest -b android-11.0.0_r4

         repo sync -j32 --optimized-fetch --current-branch --no-tags



**BUILDING**
1. Building the kernel and aosp with required changes is covered in individual folders.



**BOOTING**
1. Booting the bb from sd card is covered under sdcard section.



    
