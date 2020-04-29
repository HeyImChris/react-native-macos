<<<<<<< HEAD
/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the LICENSE
 * file in the root directory of this source tree.
 */
=======
/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

>>>>>>> fb/0.62-stable
package com.facebook.yoga;

public class YogaNodeJNIFinalizer extends YogaNodeJNIBase {
  public YogaNodeJNIFinalizer() {
    super();
  }

  public YogaNodeJNIFinalizer(YogaConfig config) {
    super(config);
  }

  @Override
  protected void finalize() throws Throwable {
    try {
      freeNatives();
    } finally {
      super.finalize();
    }
   }

  public void freeNatives() {
    if (mNativePointer != 0) {
      long nativePointer = mNativePointer;
      mNativePointer = 0;
<<<<<<< HEAD
      YogaNative.jni_YGNodeFree(nativePointer);
=======
      YogaNative.jni_YGNodeFreeJNI(nativePointer);
>>>>>>> fb/0.62-stable
    }
  }
}
