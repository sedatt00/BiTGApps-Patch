#!/sbin/sh
#
##############################################################
# File name       : installer.sh
#
# Description     : Setup installation, environmental variables and helper functions
#
# Build Date      : Friday March 15 11:36:43 IST 2019
#
# Updated on      : Friday October 25 11:27:10 IST 2019
#
# GitHub          : TheHitMan7 <krtik.vrma@gmail.com>
#
# BiTGApps Author : TheHitMan @ xda-developers
#
# Copyright       : Copyright (C) 2019 TheHitMan7
#
# License         : SPDX-License-Identifier: GPL-3.0-or-later
#
# The BiTGApps scripts are free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# These scripts are distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
##############################################################

# Check and set existing fstab used by recovery
fstab() {
 if [ -f /etc/recovery.fstab ];
 then
   FSTAB="/etc/recovery.fstab"
 elif [ -f /etc/fstab ];
 then
   FSTAB="/etc/fstab"
 elif [ -f /etc/recovery.fstab ] & [ -f /etc/fstab ];
 then
   FSTAB="/etc/recovery.fstab"
 else
   echo "ERROR: Unable to find fstab from recovery" 2>/dev/null;
 fi
}
#fstab; // function disabled

PROPFILES="/system/build.prop /system/system/build.prop /system_root/system/build.prop"

get_file_prop() {
  grep -m1 "^$2=" "$1" | cut -d= -f2
}

get_prop() {
  #check known .prop files using get_file_prop
  for f in $PROPFILES; do
    if [ -e "$f" ]; then
      prop="$(get_file_prop "$f" "$1")"
      if [ -n "$prop" ]; then
        break #if an entry has been found, break out of the loop
      fi
    fi
  done
  #if prop is still empty; try to use recovery's built-in getprop method; otherwise output current result
  if [ -z "$prop" ]; then
    getprop "$1" | cut -c1-
  else
    printf "$prop"
  fi
}

# Android sdk check
android_sdk="$(get_prop "ro.build.version.sdk")";

on_install() {
 # Set variable and log path
 CHECK="/cache/bitgapps/check_fs.log"
 FILES="/cache/bitgapps/files.log"
 rm -rf /cache/bitgapps
 mkdir /cache/bitgapps
 chmod 1755 /cache/bitgapps
 # Detect A/B partition layout https://source.android.com/devices/tech/ota/ab_updates
 # and system-as-root https://source.android.com/devices/bootloader/system-as-root
 if [ "$android_sdk" = "29" ]; then
   if [ -n "$(cat /proc/cmdline | grep slot_suffix)" ]; then
     device_abpartition=true
     SYSTEM_MOUNT=/system
     SYSTEM=$SYSTEM_MOUNT
     VENDOR=/vendor
   elif [ -n "$(cat $FSTAB | grep /system_root)" ]; then
     device_abpartition=false
     SYSTEM_MOUNT=/system_root
     SYSTEM=$SYSTEM_MOUNT/system
     VENDOR=/vendor
   else
     device_abpartition=false
     SYSTEM_MOUNT=/system
     SYSTEM=$SYSTEM_MOUNT
     VENDOR=/vendor
   fi
   echo "--------------------" >> $CHECK
   echo "    About Device    " >> $CHECK
   echo "--------------------" >> $CHECK
   echo " " >> $CHECK
   echo "- has Android SDK Version 29" >> $CHECK
   echo "- has Android Version 10" >> $CHECK
   if [ -n "$(cat /proc/cmdline | grep slot_suffix)" ]; then
     echo "- has device_abpartition=true" >> $CHECK
     echo "- has A/B Partition" >> $CHECK
   elif [ -n "$(cat /etc/recovery.fstab | grep /system_root)" ]; then
     echo "- has device_abpartition=false" >> $CHECK
     echo "- has system-as-root Partition=true" >> $CHECK
   else
     echo "- has device_abpartition=false" >> $CHECK
     echo "- has A-only Partition=true" >> $CHECK
   fi
 elif [ "$android_sdk" = "28" ]; then
   if [ -n "$(cat /proc/cmdline | grep slot_suffix)" ]; then
     SYSTEM_MOUNT=/system
     SYSTEM=$SYSTEM_MOUNT/system
     VENDOR=/vendor
   elif [ -n "$(cat $FSTAB | grep /system_root)" ]; then
     SYSTEM_MOUNT=/system_root
     SYSTEM=$SYSTEM_MOUNT/system
     VENDOR=/vendor
   else
     SYSTEM_MOUNT=/system
     SYSTEM=$SYSTEM_MOUNT
     VENDOR=/vendor
   fi
   echo "--------------------" >> $CHECK
   echo "    About Device    " >> $CHECK
   echo "--------------------" >> $CHECK
   echo " " >> $CHECK
   echo "- has Android SDK Version 28" >> $CHECK
   echo "- has Android Version 9" >> $CHECK
   if [ -n "$(cat /proc/cmdline | grep slot_suffix)" ]; then
     echo "- has device_abpartition=true" >> $CHECK
     echo "- has A/B Partition" >> $CHECK
   elif [ -n "$(cat $FSTAB | grep /system_root)" ]; then
     echo "- has device_abpartition=false" >> $CHECK
     echo "- has system-as-root Partition=true" >> $CHECK
   else
     echo "- has device_abpartition=false" >> $CHECK
     echo "- has A-only Partition=true" >> $CHECK
   fi
 elif [ "$android_sdk" = "27" ]; then
   if [ -n "$(cat /proc/cmdline | grep slot_suffix)" ]; then
     SYSTEM_MOUNT=/system
     SYSTEM=$SYSTEM_MOUNT/system
     VENDOR=/vendor
   elif [ -n "$(cat $FSTAB | grep /system_root)" ]; then
     SYSTEM_MOUNT=/system_root
     SYSTEM=$SYSTEM_MOUNT/system
     VENDOR=/vendor
   else
     SYSTEM_MOUNT=/system
     SYSTEM=$SYSTEM_MOUNT
     VENDOR=/vendor
   fi
   echo "--------------------" >> $CHECK
   echo "    About Device    " >> $CHECK
   echo "--------------------" >> $CHECK
   echo " " >> $CHECK
   echo "- has Android SDK Version 27" >> $CHECK
   echo "- has Android Version 8.1.0" >> $CHECK
   if [ -n "$(cat /proc/cmdline | grep slot_suffix)" ]; then
     echo "- has device_abpartition=true" >> $CHECK
     echo "- has A/B Partition" >> $CHECK
   elif [ -n "$(cat $FSTAB | grep /system_root)" ]; then
     echo "- has device_abpartition=false" >> $CHECK
     echo "- has system-as-root Partition=true" >> $CHECK
   else
     echo "- has device_abpartition=false" >> $CHECK
     echo "- has A-only Partition=true" >> $CHECK
   fi
 elif [ "$android_sdk" = "25" ]; then
   if [ -n "$(cat /proc/cmdline | grep slot_suffix)" ]; then
     SYSTEM_MOUNT=/system
     SYSTEM=$SYSTEM_MOUNT/system
     VENDOR=/system/vendor
   elif [ -n "$(cat $FSTAB | grep /system_root)" ]; then
     SYSTEM_MOUNT=/system_root
     SYSTEM=$SYSTEM_MOUNT/system
     VENDOR=/system/vendor
   else
     SYSTEM_MOUNT=/system
     SYSTEM=$SYSTEM_MOUNT
     VENDOR=/system/vendor
   fi
   echo "--------------------" >> $CHECK
   echo "    About Device    " >> $CHECK
   echo "--------------------" >> $CHECK
   echo " " >> $CHECK
   echo "- has Android SDK Version 25" >> $CHECK
   echo "- has Android Version 7.1.2" >> $CHECK
   if [ -n "$(cat /proc/cmdline | grep slot_suffix)" ]; then
     echo "- has device_abpartition=true" >> $CHECK
     echo "- has A/B Partition" >> $CHECK
   elif [ -n "$(cat $FSTAB | grep /system_root)" ]; then
     echo "- has device_abpartition=false" >> $CHECK
     echo "- has system-as-root Partition=true" >> $CHECK
   else
     echo "- has device_abpartition=false" >> $CHECK
     echo "- has A-only Partition=true" >> $CHECK
   fi
 else
     echo "ERROR 10: Unable to get partition layout"; >> $CHECK
 fi;
 # Apply patch
 SYSTEM_PRIV_APP="$SYSTEM/priv-app"
 rm -rf $SYSTEM_PRIV_APP/Velvet
 mkdir $SYSTEM_PRIV_APP/Velvet
 mkdir $SYSTEM_PRIV_APP/Velvet/lib
 mkdir $SYSTEM_PRIV_APP/Velvet/lib/arm
 mkdir $SYSTEM_PRIV_APP/Velvet/lib/arm64
 chmod 0755 $SYSTEM_PRIV_APP/Velvet
 chmod 0755 $SYSTEM_PRIV_APP/Velvet/lib
 chmod 0755 $SYSTEM_PRIV_APP/Velvet/lib/arm
 chmod 0755 $SYSTEM_PRIV_APP/Velvet/lib/arm64
 cp -f /data/app/com.google.android.googlequicksearchbox*/base.apk $SYSTEM_PRIV_APP/Velvet/Velvet.apk
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm/libmultiarch_dummy.so $SYSTEM_PRIV_APP/Velvet/lib/arm/libmultiarch_dummy.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libagsa-annotations.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libagsa-annotations.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libandroid_dtmf.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libandroid_dtmf.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libandroid_jingle.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libandroid_jingle.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libarcore_sdk_c.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libarcore_sdk_c.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libarcore_sdk_jni.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libarcore_sdk_jni.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libbrotli.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libbrotli.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libcronet.79.0.3921.2.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libcronet.79.0.3921.2.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libframesequence.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libframesequence.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libgeller_jni_lib.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libgeller_jni_lib.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libgoogle_speech_jni.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libgoogle_speech_jni.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libgoogle_speech_micro_jni.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libgoogle_speech_micro_jni.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/liblens_image_util.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/liblens_image_util.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/liblens_vision.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/liblens_vision.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libnativecrashreporter.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libnativecrashreporter.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/liboffline_actions_jni.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/liboffline_actions_jni.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libogg_opus_encoder.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libogg_opus_encoder.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libopuscodec.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libopuscodec.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libsbcdecoder_jni.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libsbcdecoder_jni.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libscene_viewer_jni.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libscene_viewer_jni.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libunified_template_resolver.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libunified_template_resolver.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libvcdiffjni.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libvcdiffjni.so 2>/dev/null
 cp -f /data/app/com.google.android.googlequicksearchbox*/lib/arm64/libyoga.so $SYSTEM_PRIV_APP/Velvet/lib/arm64/libyoga.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/Velvet.apk
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm/libmultiarch_dummy.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libagsa-annotations.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libandroid_dtmf.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libandroid_jingle.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libarcore_sdk_c.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libarcore_sdk_jni.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libbrotli.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libcronet.79.0.3921.2.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libframesequence.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libgeller_jni_lib.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libgoogle_speech_jni.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libgoogle_speech_micro_jni.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/liblens_image_util.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/liblens_vision.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libnativecrashreporter.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/liboffline_actions_jni.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libogg_opus_encoder.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libopuscodec.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libsbcdecoder_jni.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libscene_viewer_jni.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libunified_template_resolver.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libvcdiffjni.so 2>/dev/null
 chmod 0644 $SYSTEM_PRIV_APP/Velvet/lib/arm64/libyoga.so 2>/dev/null
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/Velvet.apk";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm/libmultiarch_dummy.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libagsa-annotations.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libandroid_dtmf.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libandroid_jingle.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libarcore_sdk_c.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libarcore_sdk_jni.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libbrotli.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libcronet.79.0.3921.2.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libframesequence.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libgeller_jni_lib.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libgoogle_speech_jni.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libgoogle_speech_micro_jni.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/liblens_image_util.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/liblens_vision.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libnativecrashreporter.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/liboffline_actions_jni.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libogg_opus_encoder.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libopuscodec.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libsbcdecoder_jni.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libscene_viewer_jni.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libunified_template_resolver.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libvcdiffjni.so" 2>/dev/null;
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Velvet/lib/arm64/libyoga.so" 2>/dev/null;
 rm -rf /data/app/com.google.android.googlequicksearchbox*
 ls $SYSTEM_PRIV_APP/Velvet/Velvet.apk >> $FILES
}

# execute install function
on_install;

# end method
