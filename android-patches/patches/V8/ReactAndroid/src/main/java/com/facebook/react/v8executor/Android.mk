--- "E:\\github\\rnm-63-fresh\\ReactAndroid\\src\\main\\java\\com\\facebook\\react\\v8executor\\Android.mk"	1969-12-31 16:00:00.000000000 -0800
+++ "E:\\github\\rnm-63\\ReactAndroid\\src\\main\\java\\com\\facebook\\react\\v8executor\\Android.mk"	2020-10-13 21:39:46.668978500 -0700
@@ -0,0 +1,21 @@
+# Copyright (c) Facebook, Inc. and its affiliates.
+#
+# This source code is licensed under the MIT license found in the
+# LICENSE file in the root directory of this source tree.
+
+LOCAL_PATH := $(call my-dir)
+
+include $(CLEAR_VARS)
+
+LOCAL_MODULE := v8executor
+
+LOCAL_SRC_FILES := $(wildcard $(LOCAL_PATH)/*.cpp)
+
+LOCAL_C_INCLUDES := $(LOCAL_PATH) $(THIRD_PARTY_NDK_DIR)/..
+
+LOCAL_CFLAGS += -fvisibility=hidden -fexceptions -frtti
+
+LOCAL_STATIC_LIBRARIES := libjsi libjsireact
+LOCAL_SHARED_LIBRARIES := libfolly_json libfb libfbjni libreactnativejni v8jsi
+
+include $(BUILD_SHARED_LIBRARY)
