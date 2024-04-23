OVERVIEW

We will boot the Beaglebone from Emmc and then press space in serial terminal to stop the autoboot.

Then will load the zImage, dtb and Ramdisk from the SD card first partition.

I have used 16 GB SD card.

SD card partitions:

/dev/mmcblk0p1(1GB)  :For storing zImage, dtb and ramdisk ) 
/dev/mmcblk0p2 (4GB ):For system.img
/dev/mmcblk0p3  (2GB) :For vendor.img
/dev/mmcblk0p4 (1GB) :For userdata.img


Steps:

1. Make SD card partitions using fdisk.

Reference: 
https://www.armhf.com/boards/beaglebone-black/bbb-sd-install/

2. Copy zImage , dtb and Ramdisk generated in Kernel and aosp section to /dev/mmcblk0p1 ( Make sure you have formatted this with vfat).

3. Issue below commands to flash aosp images to partitions.
		sudo dd if=system.img of=/dev/mmcblk0p2 bs=1M
		
		sudo dd if=vendor.img of=/dev/mmcblk0p3 bs=1M
		
		sudo dd if=userdata.img of=/dev/mmcblk0p4 bs=1M
		
4. Connect the beaglbone  to power supply, I have used serial cable for looking at logs and dropping to shell, power up the baord and press spacebar on keyboard as soon as prompt asks to do so,snippet shown below.


U-Boot 2019.04-00002-gf15b99f0b6 (Oct 01 2019 - 09:28:05 -0500), Build: jenkins-github_Bootloader-Builder-131

CPU  : AM335X-GP rev 2.1
I2C:   ready
DRAM:  512 MiB
No match for driver 'omap_hsmmc'
No match for driver 'omap_hsmmc'
Some drivers were not found
Reset Source: Global external warm reset has occurred.
Reset Source: Global warm SW reset has occurred.
Reset Source: Power-on reset has occurred.
RTC 32KCLK Source: External.
MMC:   OMAP SD/MMC: 0, OMAP SD/MMC: 1
Loading Environment from EXT4...
** Unable to use mmc 0:1 for loading the env **
Board: BeagleBone Black
<ethaddr> not set. Validating first E-fuse MAC
BeagleBone Black:
BeagleBone: cape eeprom: i2c_probe: 0x54:
BeagleBone: cape eeprom: i2c_probe: 0x55:
BeagleBone: cape eeprom: i2c_probe: 0x56:
BeagleBone: cape eeprom: i2c_probe: 0x57:
Net:   eth0: MII MODE
cpsw, usb_ether
Press SPACE to abort autoboot in 2 seconds
=>
=>


5. Now issue the below commands 

		fatload mmc 0:1 0x80200000 zImage

		fatload mmc 0:1 0x80f00000 am335x-boneblack.dtb

		fatload mmc 0:1 0x81000000 uRamdisk10

		setenv bootargs console=ttyO0,115200n8 androidboot.console=ttyO0 root=/dev/ram0 init=/init loglevel=9 androidboot.selinux=permissive print-fatal-signals=1 

		bootz 0x80200000 0x81000000 0x80f00000
		
		
6. You should see the boot logs of android and if you have done everything as is mentioned in the repo , you should see the boot crash :)

	
console:/ $ [   44.072483] potentially unexpected fatal signal 6.
[   44.077340] CPU: 0 PID: 231 Comm: android.hardwar Not tainted 5.4.268-android11-2-00008-g66f4b04cb072-dirty #1
[   44.087548] Hardware name: Generic AM33XX (Flattened Device Tree)
[   44.093716] PC is at 0xb24caa14
[   44.096871] LR is at 0xb24caa01
[   44.100071] pc : [<b24caa14>]    lr : [<b24caa01>]    psr: 00000030
[   44.106366] sp : beb32fd0  ip : 000000e7  fp : beb33020
[   44.111657] r10: beb33030  r9 : beb33010  r8 : beb33000
[   44.116905] r7 : 0000016b  r6 : 000000e7  r5 : beb32ff8  r4 : beb33014
[   44.123483] r3 : beb33000  r2 : 00000006  r1 : 000000e7  r0 : 00000000
[   44.130060] Flags: nzcv  IRQs on  FIQs on  Mode USER_32  ISA Thumb  Segment user
[   44.137488] Control: 10c5387d  Table: 9bf60019  DAC: 00000055
[   44.143284] CPU: 0 PID: 231 Comm: android.hardwar Not tainted 5.4.268-android11-2-00008-g66f4b04cb072-dirty #1
[   44.153328] Hardware name: Generic AM33XX (Flattened Device Tree)
[   44.159483] [<c0114174>] (unwind_backtrace) from [<c010e12c>] (show_stack+0x10/0x14)
[   44.167272] [<c010e12c>] (show_stack) from [<c0d963c4>] (dump_stack+0xa8/0xdc)
[   44.174544] [<c0d963c4>] (dump_stack) from [<c015c19c>] (get_signal+0x7ac/0xa2c)
[   44.181979] [<c015c19c>] (get_signal) from [<c010d168>] (do_work_pending+0x150/0x560)
[   44.189848] [<c010d168>] (do_work_pending) from [<c010106c>] (slow_work_pending+0xc/0x20)
[   44.198061] Exception stack(0xdb86dfb0 to 0xdb86dff8)
[   44.203137] dfa0:                                     00000000 000000e7 00000006 beb33000
[   44.211355] dfc0: beb33014 beb32ff8 000000e7 0000016b beb33000 beb33010 beb33030 beb33020
[   44.219571] dfe0: 000000e7 beb32fd0 b24caa01 b24caa14 00000030 00000000
[   44.283293] logd: logdr: UID=1000 GID=1000 PID=295 n tail=0 logMask=1 pid=244 start=0ns timeout=0ns
[   44.411958] DEBUG:
[   44.414113] DEBUG: backtrace:
[   44.414516] DEBUG:       #00 pc 00038a14  /apex/com.android.runtime/lib/bionic/libc.so (abort+172) (BuildId: 53f341db503cb20cc8776c067ff091a0)
[   44.417749] DEBUG:       #01 pc 00004c17  /system/lib/liblog.so (__android_log_default_aborter+6) (BuildId: 7341d20174ef220fb095f2b4b7ae915b)
[   44.566800] DEBUG:       #02 pc 00005337  /system/lib/liblog.so (__android_log_assert+174) (BuildId: 7341d20174ef220fb095f2b4b7ae915b)
[   44.649440] DEBUG:       #03 pc 00052abb  /system/lib/libbinder.so (android::ProcessState::ProcessState(char const*)+250) (BuildId: 5c22a160196263141cb4a4a2c57279e8)
[   44.749545] DEBUG:       #04 pc 0005294f  /system/lib/libbinder.so (android::ProcessState::self()+74) (BuildId: 5c22a160196263141cb4a4a2c57279e8)
[   44.851205] DEBUG:       #05 pc 0003d777  /system/lib/libbinder.so (void std::__1::__call_once_proxy<std::__1::tuple<android::defaultServiceManager()::$_0&&> >(void*)+62) (BuildId: 5c22a160196263141cb4a4a2c57279e8)
[   44.869107] potentially unexpected fatal signal 6.
[   44.931648] logd: logdr: UID=1000 GID=1003 PID=271 n tail=0 logMask=1 pid=200 start=0ns timeout=0ns
[   44.941281] CPU: 0 PID: 244 Comm: android.hardwar Not tainted 5.4.268-android11-2-00008-g66f4b04cb072-dirty #1
[   44.951455] Hardware name: Generic AM33XX (Flattened Device Tree)
[   44.957590] PC is at 0xac954a14
[   44.960776] LR is at 0xac954a01
[   44.963931] pc : [<ac954a14>]    lr : [<ac954a01>]    psr: 00000030
[   44.970244] sp : bea64fb0  ip : 000000f4  fp : bea65000
[   44.975490] r10: bea65010  r9 : bea64ff0  r8 : bea64fe0
[   44.980755] r7 : 0000016b  r6 : 000000f4  r5 : bea64fd8  r4 : bea64ff4
[   44.987312] r3 : bea64fe0  r2 : 00000006  r1 : 000000f4  r0 : 00000000
[   44.993889] Flags: nzcv  IRQs on  FIQs on  Mode USER_32  ISA Thumb  Segment user
[   45.001336] Control: 10c5387d  Table: 9bfc0019  DAC: 00000055
[   45.007110] CPU: 0 PID: 244 Comm: android.hardwar Not tainted 5.4.268-android11-2-00008-g66f4b04cb072-dirty #1
[   45.017152] Hardware name: Generic AM33XX (Flattened Device Tree)
[   45.023307] [<c0114174>] (unwind_backtrace) from [<c010e12c>] (show_stack+0x10/0x14)
[   45.031096] [<c010e12c>] (show_stack) from [<c0d963c4>] (dump_stack+0xa8/0xdc)
[   45.038369] [<c0d963c4>] (dump_stack) from [<c015c19c>] (get_signal+0x7ac/0xa2c)
[   45.045804] [<c015c19c>] (get_signal) from [<c010d168>] (do_work_pending+0x150/0x560)
[   45.053674] [<c010d168>] (do_work_pending) from [<c010106c>] (slow_work_pending+0xc/0x20)
[   45.061886] Exception stack(0xdbfeffb0 to 0xdbfefff8)
[   45.066963] ffa0:                                     00000000 000000f4 00000006 bea64fe0
[   45.075181] ffc0: bea64ff4 bea64fd8 000000f4 0000016b bea64fe0 bea64ff0 bea65010 bea65000
[   45.083398] ffe0: 000000f4 bea64fb0 ac954a01 ac954a14 00000030 00000000
[   45.195122] DEBUG: *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
[   45.195685] DEBUG: Build fingerprint: 'Android/beagle_bb/beagle_bb:11/RP1A.201005.004/eng.deepak.20240411.140333:userdebug/test-keys'
[   45.216034] DEBUG:       #06 pc 00068781  /system/lib/libc++.so (std::__1::__call_once(unsigned long volatile&, void*, void (*)(void*))+76) (BuildId: 89f7bff5c7ffd01410262f67474407d7)
[   45.319680] DEBUG: Revision: '0'
[   45.369639] DEBUG:       #07 pc 0003c0f5  /system/lib/libbinder.so (android::defaultServiceManager()+48) (BuildId: 5c22a160196263141cb4a4a2c57279e8)
[   45.373322] DEBUG:       #08 pc 0000175f  /system/bin/mediametrics (main+70) (BuildId: abb2388e66d35218fdcc9aa24605ef21)
[   45.525718] DEBUG: ABI: 'arm'
[   45.607100] DEBUG:       #09 pc 00033237  /apex/com.android.runtime/lib/bionic/libc.so (__libc_init+66) (BuildId: 53f341db503cb20cc8776c067ff091a0)
[   45.727197] DEBUG: *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
[   45.749832] DEBUG: Timestamp: 1970-01-01 00:00:45+0000
[   45.757859] DEBUG: pid: 557, tid: 557, name: android.hidl.al  >>> /system/bin/hw/android.hidl.allocator@1.0-service <<<
[   45.772938] type=1400 audit(45.750:46): avc: denied { read } for comm="android.hardwar" name="vndbinder" dev="binder" ino=6 scontext=u:r:hal_camera_default:s0 tcontext=u:object_r:vndbinder_device:s0 tclass=chr_file permissive=1
[   45.933891] DEBUG: uid: 1000
[   45.934189] DEBUG: signal 6 (SIGABRT), code -1 (SI_QUEUE), fault addr --------
[   45.937479] DEBUG: Abort message: 'Binder driver could not be opened. Terminating.'
[   45.980730] DEBUG: Build fingerprint: 'Android/beagle_bb/beagle_bb:11/RP1A.201005.004/eng.deepak.20240411.140333:userdebug/test-keys'
[   46.449525] DEBUG:     r0  00000000  r1  0000022d  r2  00000006  r3  bebe4028
[   46.486852] libprocessgroup: Failed to open /dev/cpuset/camera-daemon/tasks: No such file or directory: No such file or directory
[   46.649282] DEBUG: Revision: '0'
[   46.649677] DEBUG: ABI: 'arm'
[   46.653518] DEBUG: Timestamp: 1970-01-01 00:00:46+0000
[   46.656713] DEBUG: pid: 556, tid: 556, name: iorapd  >>> /system/bin/iorapd <<<
[   46.825313] DEBUG: *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
[   46.837593] potentially unexpected fatal signal 6.
[   46.892383] DEBUG: *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
[   46.892876] DEBUG: Build fingerprint: 'Android/beagle_bb/beagle_bb:11/RP1A.201005.004/eng.deepak.20240411.140333:userdebug/test-keys'
[   46.900947] DEBUG: Revision: '0'
[   46.913740] DEBUG: ABI: 'arm'
[   46.917540] DEBUG: Timestamp: 1970-01-01 00:00:46+0000
[   46.920854] DEBUG: pid: 582, tid: 582, name: app_process  >>> /system/bin/app_process <<<
[   46.926172] DEBUG: uid: 0
[   46.939234] DEBUG: signal 6 (SIGABRT), code -1 (SI_QUEUE), fault addr --------
[   46.942461] DEBUG: Abort message: 'Error creating cache dir /data/dalvik-cache/arm : No such file or directory'
[   46.950222] DEBUG:     r0  00000000  r1  00000246  r2  00000006  r3  be942fa0
[   46.960633] DEBUG:     r4  be942fb4  r5  be942f98  r6  00000246  r7  0000016b
[   46.967973] DEBUG:     r8  be942fa0  r9  be942fb0  r10 be942fd0  r11 be942fc0
[   46.975448] DEBUG:     ip  00000246  sp  be942f70  lr  a6691a01  pc  a6691a14
[   46.995016] DEBUG:
[   47.004488] DEBUG: backtrace:
[   47.004849] DEBUG:       #00 pc 00038a14  /apex/com.android.runtime/lib/bionic/libc.so (abort+172) (BuildId: 53f341db503cb20cc8776c067ff091a0)
[   47.008083] DEBUG:       #01 pc 00004c17  /system/lib/liblog.so (__android_log_default_aborter+6) (BuildId: 7341d20174ef220fb095f2b4b7ae915b)
[   47.021384] DEBUG:       #02 pc 00005337  /system/lib/liblog.so (__android_log_assert+174) (BuildId: 7341d20174ef220fb095f2b4b7ae915b)
[   47.034453] DEBUG:       #03 pc 00002f73  /system/bin/app_process32 (main+1302) (BuildId: 1c021fad54475991613438fb49dc9430)
[   47.047128] DEBUG:       #04 pc 00033237  /apex/com.android.runtime/lib/bionic/libc.so (__libc_init+66) (BuildId: 53f341db503cb20cc8776c067ff091a0)
[   47.145672] libprocessgroup: Failed to open /dev/stune/foreground/tasks: No such file or directory: No such file or directory
[   47.419247] CPU: 0 PID: 200 Comm: android.hardwar Not tainted 5.4.268-android11-2-00008-g66f4b04cb072-dirty #1
[   47.429427] Hardware name: Generic AM33XX (Flattened Device Tree)
[   47.435561] PC is at 0xb56d2a14
[   47.438750] LR is at 0xb56d2a01
[   47.441906] pc : [<b56d2a14>]    lr : [<b56d2a01>]    psr: 00000030
[   47.448244] sp : be88bff8  ip : 000000c8  fp : be88c048
[   47.453525] r10: be88c058  r9 : be88c038  r8 : be88c028
[   47.458795] r7 : 0000016b  r6 : 000000c8  r5 : be88c020  r4 : be88c03c
[   47.465352] r3 : be88c028  r2 : 00000006  r1 : 000000c8  r0 : 00000000
[   47.471929] Flags: nzcv  IRQs on  FIQs on  Mode USER_32  ISA Thumb  Segment user
[   47.479392] Control: 10c5387d  Table: 9bd80019  DAC: 00000055
[   47.485167] CPU: 0 PID: 200 Comm: android.hardwar Not tainted 5.4.268-android11-2-00008-g66f4b04cb072-dirty #1
[   47.495208] Hardware name: Generic AM33XX (Flattened Device Tree)
[   47.501363] [<c0114174>] (unwind_backtrace) from [<c010e12c>] (show_stack+0x10/0x14)
[   47.509153] [<c010e12c>] (show_stack) from [<c0d963c4>] (dump_stack+0xa8/0xdc)
[   47.516425] [<c0d963c4>] (dump_stack) from [<c015c19c>] (get_signal+0x7ac/0xa2c)
[   47.523858] [<c015c19c>] (get_signal) from [<c010d168>] (do_work_pending+0x150/0x560)
[   47.531728] [<c010d168>] (do_work_pending) from [<c010106c>] (slow_work_pending+0xc/0x20)
[   47.539941] Exception stack(0xdbd2bfb0 to 0xdbd2bff8)
[   47.545018] bfa0:                                     00000000 000000c8 00000006 be88c028
[   47.553235] bfc0: be88c03c be88c020 000000c8 0000016b be88c028 be88c038 be88c058 be88c048
[   47.561451] bfe0: 000000c8 be88bff8 b56d2a01 b56d2a14 00000030 00000000
[   47.571061] potentially unexpected fatal signal 6.
[   47.575907] CPU: 0 PID: 212 Comm: android.hardwar Not tainted 5.4.268-android11-2-00008-g66f4b04cb072-dirty #1
[   47.586049] Hardware name: Generic AM33XX (Flattened Device Tree)
[   47.592233] PC is at 0xb3200a14
[   47.595389] LR is at 0xb3200a01
[   47.598543] pc : [<b3200a14>]    lr : [<b3200a01>]    psr: 00000030
[   47.604863] sp : beba7ff0  ip : 000000d4  fp : beba8040
[   47.610132] r10: beba8050  r9 : beba8030  r8 : beba8020
[   47.615378] r7 : 0000016b  r6 : 000000d4  r5 : beba8018  r4 : beba8034
[   47.621968] r3 : beba8020  r2 : 00000006  r1 : 000000d4  r0 : 00000000
[   47.628528] Flags: nzcv  IRQs on  FIQs on  Mode USER_32  ISA Thumb  Segment user
[   47.635979] Control: 10c5387d  Table: 9bec4019  DAC: 00000055
[   47.641774] CPU: 0 PID: 212 Comm: android.hardwar Not tainted 5.4.268-android11-2-00008-g66f4b04cb072-dirty #1
[   47.651816] Hardware name: Generic AM33XX (Flattened Device Tree)
[   47.657966] [<c0114174>] (unwind_backtrace) from [<c010e12c>] (show_stack+0x10/0x14)
[   47.665755] [<c010e12c>] (show_stack) from [<c0d963c4>] (dump_stack+0xa8/0xdc)
[   47.673026] [<c0d963c4>] (dump_stack) from [<c015c19c>] (get_signal+0x7ac/0xa2c)
[   47.680459] [<c015c19c>] (get_signal) from [<c010d168>] (do_work_pending+0x150/0x560)
[   47.688329] [<c010d168>] (do_work_pending) from [<c010106c>] (slow_work_pending+0xc/0x20)
[   47.696541] Exception stack(0xdbde7fb0 to 0xdbde7ff8)
[   47.701617] 7fa0:                                     00000000 000000d4 00000006 beba8020
[   47.709835] 7fc0: beba8034 beba8018 000000d4 0000016b beba8020 beba8030 beba8050 beba8040
[   47.718050] 7fe0: 000000d4 beba7ff0 b3200a01 b3200a14 00000030 00000000
[   47.727897] potentially unexpected fatal signal 6.
[   47.736981] CPU: 0 PID: 236 Comm: android.hardwar Not tainted 5.4.268-android11-2-00008-g66f4b04cb072-dirty #1
[   47.747163] Hardware name: Generic AM33XX (Flattened Device Tree)
[   47.753363] PC is at 0xb0853a14
[   47.756519] LR is at 0xb0853a01
[   47.759699] pc : [<b0853a14>]    lr : [<b0853a01>]    psr: 00000030
[   47.765994] sp : bec7ffd0  ip : 000000ec  fp : bec80020
[   47.771263] r10: bec80030  r9 : bec80010  r8 : bec80000
[   47.776511] r7 : 0000016b  r6 : 000000ec  r5 : bec7fff8  r4 : bec80014
[   47.783086] r3 : bec80000  r2 : 00000006  r1 : 000000ec  r0 : 00000000
[   47.789664] Flags: nzcv  IRQs on  FIQs on  Mode USER_32  ISA Thumb  Segment user
[   47.797092] Control: 10c5387d  Table: 9bf9c019  DAC: 00000055
[   47.802887] CPU: 0 PID: 236 Comm: android.hardwar Not tainted 5.4.268-android11-2-00008-g66f4b04cb072-dirty #1
[   47.812930] Hardware name: Generic AM33XX (Flattened Device Tree)
[   47.819085] [<c0114174>] (unwind_backtrace) from [<c010e12c>] (show_stack+0x10/0x14)
[   47.826873] [<c010e12c>] (show_stack) from [<c0d963c4>] (dump_stack+0xa8/0xdc)
[   47.834144] [<c0d963c4>] (dump_stack) from [<c015c19c>] (get_signal+0x7ac/0xa2c)
[   47.841578] [<c015c19c>] (get_signal) from [<c010d168>] (do_work_pending+0x150/0x560)
[   47.849448] [<c010d168>] (do_work_pending) from [<c010106c>] (slow_work_pending+0xc/0x20)
[   47.857661] Exception stack(0xdbec9fb0 to 0xdbec9ff8)
[   47.862739] 9fa0:                                     00000000 000000ec 00000006 bec80000
[   47.870957] 9fc0: bec80014 bec7fff8 000000ec 0000016b bec80000 bec80010 bec80030 bec80020
[   47.879172] 9fe0: 000000ec bec7ffd0 b0853a01 b0853a14 00000030 00000000
[   47.893024] DEBUG: Build fingerprint: 'Android/beagle_bb/beagle_bb:11/RP1A.201005.004/eng.deepak.20240411.140333:userdebug/test-keys'
[   47.893391] DEBUG: Revision: '0'
[   47.910999] DEBUG:     r4  bebe403c  r5  bebe4020  r6  0000022d  r7  0000016b
[   47.914493] DEBUG:     r8  bebe4028  r9  bebe4038  r10 bebe4058  r11 bebe4048
[   47.939417] DEBUG: uid: 1071
[   47.946843] DEBUG: signal 6 (SIGABRT), code -1 (SI_QUEUE), fault addr --------
[   47.961728] init: starting service 'wificond'...
[   47.977339] DEBUG: *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
[   47.977837] DEBUG: Build fingerprint: 'Android/beagle_bb/beagle_bb:11/RP1A.201005.004/eng.deepak.20240411.140333:userdebug/test-keys'
[   47.995736] libprocessgroup: Failed to open /dev/stune/foreground/tasks: No such file or directory: No such file or directory
[   48.064747] DEBUG: *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
[   48.065242] DEBUG: Build fingerprint: 'Android/beagle_bb/beagle_bb:11/RP1A.201005.004/eng.deepak.20240411.140333:userdebug/test-keys'
[   48.078972] logd: logdr: UID=9999 GID=0 PID=303 n tail=0 logMask=1 pid=228 start=0ns timeout=0ns
[   48.106955] DEBUG: *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
[   48.107395] DEBUG: Build fingerprint: 'Android/beagle_bb/beagle_bb:11/RP1A.201005.004/eng.deepak.20240411.140333:userdebug/test-keys'
[   48.115771] DEBUG:     ip  0000022d  sp  bebe3ff8  lr  a7009a01  pc  a7009a14
[   48.131756] DEBUG: Abort message: 'Failed to open DB: unable to open database file'
[   48.139526] DEBUG: ABI: 'arm'
[   48.147765] DEBUG: Timestamp: 1970-01-01 00:00:48+0000
[   48.155180] potentially unexpected fatal signal 6.
[   48.169265] libprocessgroup: Failed to apply CameraServiceCapacity task profile: No such file or directory
[   48.179289] CPU: 0 PID: 255 Comm: android.hardwar Not tainted 5.4.268-android11-2-00008-g66f4b04cb072-dirty #1
[   48.189405] Hardware name: Generic AM33XX (Flattened Device Tree)
[   48.195538] PC is at 0xa81cea14
[   48.198722] LR is at 0xa81cea01
[   48.201877] pc : [<a81cea14>]    lr : [<a81cea01>]    psr: 00000030
[   48.208169] sp : bed94fd0  ip : 000000ff  fp : bed95020
[   48.213438] r10: bed95030  r9 : bed95010  r8 : bed95000
[   48.218706] r7 : 0000016b  r6 : 000000ff  r5 : bed94ff8  r4 : bed95014
[   48.225262] r3 : bed95000  r2 : 00000006  r1 : 0

.
.
.
.
54784689712dd27e92a0b23bc3466de2)
[  100.820523] DEBUG:       #07 pc 00033237  /apex/com.android.runtime/lib/bionic/libc.so (__libc_init+66) (BuildId: 53f341db503cb20cc8776c067ff091a0)
[  101.592379] DEBUG: *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
[  101.609509] DEBUG: Build fingerprint: 'Android/beagle_bb/beagle_bb:11/RP1A.201005.004/eng.deepak.20240411.140333:userdebug/test-keys'
[  101.617420] DEBUG: Revision: '0'
[  101.639394] DEBUG: ABI: 'arm'
[  101.643256] DEBUG: Timestamp: 1970-01-01 00:01:41+0000
[  101.646451] DEBUG: pid: 1188, tid: 1188, name: app_process  >>> /system/bin/app_process <<<
[  101.653905] DEBUG: uid: 0
[  101.663129] DEBUG: signal 6 (SIGABRT), code -1 (SI_QUEUE), fault addr --------
[  101.666359] DEBUG: Abort message: 'Error creating cache dir /data/dalvik-cache/arm : No such file or directory'
[  101.674371] DEBUG:     r0  00000000  r1  000004a4  r2  00000006  r3  beee0fa0
[  101.687045] DEBUG:     r4  beee0fb4  r5  beee0f98  r6  000004a4  r7  0000016b
[  101.694663] DEBUG:     r8  beee0fa0  r9  beee0fb0  r10 beee0fd0  r11 beee0fc0
[  101.702189] DEBUG:     ip  000004a4  sp  beee0f70  lr  ae240a01  pc  ae240a14
[  101.721438] DEBUG:
[  101.730986] DEBUG: backtrace:
[  101.731429] DEBUG:       #00 pc 00038a14  /apex/com.android.runtime/lib/bionic/libc.so (abort+172) (BuildId: 53f341db503cb20cc8776c067ff091a0)
[  101.734690] DEBUG:       #01 pc 00004c17  /system/lib/liblog.so (__android_log_default_aborter+6) (BuildId: 7341d20174ef220fb095f2b4b7ae915b)
[  101.747955] DEBUG:       #02 pc 00005337  /system/lib/liblog.so (__android_log_assert+174) (BuildId: 7341d20174ef220fb095f2b4b7ae915b)
[  101.763368] DEBUG:       #03 pc 00002f73  /system/bin/app_process32 (main+1302) (BuildId: 1c021fad54475991613438fb49dc9430)
[  101.776811] DEBUG:       #04 pc 00033237  /apex/com.android.runtime/lib/bionic/libc.so (__libc_init+66) (BuildId: 53f341db503cb20cc8776c067ff091a0)
[  102.361547] init: starting service 'gatekeeperd'...
[  102.469490] type=1400 audit(99.410:105): avc: denied { open } for comm="mediaswcodec" path="/dev/kmsg_debug" dev="tmpfs" ino=8686 scontext=u:r:mediaswcodec:s0 tcontext=u:object_r:kmsg_debug_device:s0 tclass=chr_file permissive=1
[  102.497527] DEBUG: *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
[  102.498056] DEBUG: Build fingerprint: 'Android/beagle_bb/beagle_bb:11/RP1A.201005.004/eng.deepak.20240411.140333:userdebug/test-keys'
[  102.602097] init: starting service 'hwservicemanage


Complete boot logs are attached in top folder.


		
		
		
		


