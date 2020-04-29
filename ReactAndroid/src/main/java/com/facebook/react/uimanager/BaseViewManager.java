/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

package com.facebook.react.uimanager;

import android.graphics.Color;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewParent;
<<<<<<< HEAD
=======
import android.view.accessibility.AccessibilityEvent;
>>>>>>> fb/0.62-stable
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.view.ViewCompat;
import com.facebook.common.logging.FLog;
import com.facebook.react.R;
import com.facebook.react.bridge.Dynamic;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.common.ReactConstants;
import com.facebook.react.uimanager.ReactAccessibilityDelegate.AccessibilityRole;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.util.ReactFindViewUtil;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Base class that should be suitable for the majority of subclasses of {@link ViewManager}. It
 * provides support for base view properties such as backgroundColor, opacity, etc.
 */
public abstract class BaseViewManager<T extends View, C extends LayoutShadowNode>
<<<<<<< HEAD
    extends ViewManager<T, C> {
=======
    extends ViewManager<T, C> implements BaseViewManagerInterface<T> {
>>>>>>> fb/0.62-stable

  private static final int PERSPECTIVE_ARRAY_INVERTED_CAMERA_DISTANCE_INDEX = 2;
  private static final float CAMERA_DISTANCE_NORMALIZATION_MULTIPLIER = (float) Math.sqrt(5);

  private static MatrixMathHelper.MatrixDecompositionContext sMatrixDecompositionContext =
      new MatrixMathHelper.MatrixDecompositionContext();
  private static double[] sTransformDecompositionArray = new double[16];

  public static final Map<String, Integer> sStateDescription = new HashMap<>();

  static {
    sStateDescription.put("busy", R.string.state_busy_description);
    sStateDescription.put("expanded", R.string.state_expanded_description);
    sStateDescription.put("collapsed", R.string.state_collapsed_description);
  }

  // State definition constants -- must match the definition in
  // ViewAccessibility.js. These only include states for which there
  // is no native support in android.

  private static final String STATE_CHECKED = "checked"; // Special case for mixed state checkboxes
  private static final String STATE_BUSY = "busy";
  private static final String STATE_EXPANDED = "expanded";
  private static final String STATE_MIXED = "mixed";

<<<<<<< HEAD
=======
  @Override
>>>>>>> fb/0.62-stable
  @ReactProp(
      name = ViewProps.BACKGROUND_COLOR,
      defaultInt = Color.TRANSPARENT,
      customType = "Color")
  public void setBackgroundColor(@NonNull T view, int backgroundColor) {
    view.setBackgroundColor(backgroundColor);
  }

<<<<<<< HEAD
=======
  @Override
>>>>>>> fb/0.62-stable
  @ReactProp(name = ViewProps.TRANSFORM)
  public void setTransform(@NonNull T view, @Nullable ReadableArray matrix) {
    if (matrix == null) {
      resetTransformProperty(view);
    } else {
      setTransformProperty(view, matrix);
    }
  }

  @Override
  @ReactProp(name = ViewProps.OPACITY, defaultFloat = 1.f)
  public void setOpacity(@NonNull T view, float opacity) {
    view.setAlpha(opacity);
  }

<<<<<<< HEAD
=======
  @Override
>>>>>>> fb/0.62-stable
  @ReactProp(name = ViewProps.ELEVATION)
  public void setElevation(@NonNull T view, float elevation) {
    ViewCompat.setElevation(view, PixelUtil.toPixelFromDIP(elevation));
  }

<<<<<<< HEAD
=======
  @Override
>>>>>>> fb/0.62-stable
  @ReactProp(name = ViewProps.Z_INDEX)
  public void setZIndex(@NonNull T view, float zIndex) {
    int integerZIndex = Math.round(zIndex);
    ViewGroupManager.setViewZIndex(view, integerZIndex);
    ViewParent parent = view.getParent();
    if (parent instanceof ReactZIndexedViewGroup) {
      ((ReactZIndexedViewGroup) parent).updateDrawingOrder();
    }
  }

<<<<<<< HEAD
=======
  @Override
>>>>>>> fb/0.62-stable
  @ReactProp(name = ViewProps.RENDER_TO_HARDWARE_TEXTURE)
  public void setRenderToHardwareTexture(@NonNull T view, boolean useHWTexture) {
    view.setLayerType(useHWTexture ? View.LAYER_TYPE_HARDWARE : View.LAYER_TYPE_NONE, null);
  }

<<<<<<< HEAD
  @ReactProp(name = ViewProps.TEST_ID)
  public void setTestId(@NonNull T view, String testId) {
=======
  @Override
  @ReactProp(name = ViewProps.TEST_ID)
  public void setTestId(@NonNull T view, @Nullable String testId) {
>>>>>>> fb/0.62-stable
    view.setTag(R.id.react_test_id, testId);

    // temporarily set the tag and keyed tags to avoid end to end test regressions
    view.setTag(testId);
  }

<<<<<<< HEAD
  @ReactProp(name = ViewProps.NATIVE_ID)
  public void setNativeId(@NonNull T view, String nativeId) {
=======
  @Override
  @ReactProp(name = ViewProps.NATIVE_ID)
  public void setNativeId(@NonNull T view, @Nullable String nativeId) {
>>>>>>> fb/0.62-stable
    view.setTag(R.id.view_tag_native_id, nativeId);
    ReactFindViewUtil.notifyViewRendered(view);
  }

<<<<<<< HEAD
  @ReactProp(name = ViewProps.ACCESSIBILITY_LABEL)
  public void setAccessibilityLabel(@NonNull T view, String accessibilityLabel) {
=======
  @Override
  @ReactProp(name = ViewProps.ACCESSIBILITY_LABEL)
  public void setAccessibilityLabel(@NonNull T view, @Nullable String accessibilityLabel) {
>>>>>>> fb/0.62-stable
    view.setTag(R.id.accessibility_label, accessibilityLabel);
    updateViewContentDescription(view);
  }

<<<<<<< HEAD
  @ReactProp(name = ViewProps.ACCESSIBILITY_HINT)
  public void setAccessibilityHint(@NonNull T view, String accessibilityHint) {
=======
  @Override
  @ReactProp(name = ViewProps.ACCESSIBILITY_HINT)
  public void setAccessibilityHint(@NonNull T view, @Nullable String accessibilityHint) {
>>>>>>> fb/0.62-stable
    view.setTag(R.id.accessibility_hint, accessibilityHint);
    updateViewContentDescription(view);
  }

<<<<<<< HEAD
=======
  @Override
>>>>>>> fb/0.62-stable
  @ReactProp(name = ViewProps.ACCESSIBILITY_ROLE)
  public void setAccessibilityRole(@NonNull T view, @Nullable String accessibilityRole) {
    if (accessibilityRole == null) {
      return;
    }
    view.setTag(R.id.accessibility_role, AccessibilityRole.fromValue(accessibilityRole));
  }

<<<<<<< HEAD
  @ReactProp(name = ViewProps.ACCESSIBILITY_STATES)
  public void setViewStates(@NonNull T view, @Nullable ReadableArray accessibilityStates) {
    boolean shouldUpdateContentDescription =
        view.getTag(R.id.accessibility_states) != null && accessibilityStates == null;
    view.setTag(R.id.accessibility_states, accessibilityStates);
    view.setSelected(false);
    view.setEnabled(true);
    if (accessibilityStates != null) {
      for (int i = 0; i < accessibilityStates.size(); i++) {
        String state = accessibilityStates.getString(i);
        if (sStateDescription.containsKey(state)) {
          shouldUpdateContentDescription = true;
        }
        if ("selected".equals(state)) {
          view.setSelected(true);
        } else if ("disabled".equals(state)) {
          view.setEnabled(false);
        }
=======
  @Override
  @ReactProp(name = ViewProps.ACCESSIBILITY_STATE)
  public void setViewState(@NonNull T view, @Nullable ReadableMap accessibilityState) {
    if (accessibilityState == null) {
      return;
    }
    view.setTag(R.id.accessibility_state, accessibilityState);
    view.setSelected(false);
    view.setEnabled(true);

    // For states which don't have corresponding methods in
    // AccessibilityNodeInfo, update the view's content description
    // here

    final ReadableMapKeySetIterator i = accessibilityState.keySetIterator();
    while (i.hasNextKey()) {
      final String state = i.nextKey();
      if (state.equals(STATE_BUSY)
          || state.equals(STATE_EXPANDED)
          || (state.equals(STATE_CHECKED)
              && accessibilityState.getType(STATE_CHECKED) == ReadableType.String)) {
        updateViewContentDescription(view);
        break;
      } else if (view.isAccessibilityFocused()) {
        // Internally Talkback ONLY uses TYPE_VIEW_CLICKED for "checked" and
        // "selected" announcements. Send a click event to make sure Talkback
        // get notified for the state changes that don't happen upon users' click.
        // For the state changes that happens immediately, Talkback will skip
        // the duplicated click event.
        view.sendAccessibilityEvent(AccessibilityEvent.TYPE_VIEW_CLICKED);
>>>>>>> fb/0.62-stable
      }
    }
  }

<<<<<<< HEAD
  @ReactProp(name = ViewProps.ACCESSIBILITY_STATE)
  public void setViewState(@NonNull T view, @Nullable ReadableMap accessibilityState) {
    if (accessibilityState == null) {
      return;
    }
    view.setTag(R.id.accessibility_state, accessibilityState);
    view.setSelected(false);
    view.setEnabled(true);

    // For states which don't have corresponding methods in
    // AccessibilityNodeInfo, update the view's content description
    // here

    final ReadableMapKeySetIterator i = accessibilityState.keySetIterator();
    while (i.hasNextKey()) {
      final String state = i.nextKey();
      if (state.equals(STATE_BUSY)
          || state.equals(STATE_EXPANDED)
          || (state.equals(STATE_CHECKED)
              && accessibilityState.getType(STATE_CHECKED) == ReadableType.String)) {
        updateViewContentDescription(view);
        break;
      }
    }
  }

  private void updateViewContentDescription(@NonNull T view) {
    final String accessibilityLabel = (String) view.getTag(R.id.accessibility_label);
    final ReadableArray accessibilityStates =
        (ReadableArray) view.getTag(R.id.accessibility_states);
    final ReadableMap accessibilityState = (ReadableMap) view.getTag(R.id.accessibility_state);
    final String accessibilityHint = (String) view.getTag(R.id.accessibility_hint);
    final List<String> contentDescription = new ArrayList<>();
    if (accessibilityLabel != null) {
      contentDescription.add(accessibilityLabel);
    }
    if (accessibilityStates != null) {
      for (int i = 0; i < accessibilityStates.size(); i++) {
        final String state = accessibilityStates.getString(i);
        if (sStateDescription.containsKey(state)) {
          contentDescription.add(view.getContext().getString(sStateDescription.get(state)));
        }
      }
    }
=======
  private void updateViewContentDescription(@NonNull T view) {
    final String accessibilityLabel = (String) view.getTag(R.id.accessibility_label);
    final ReadableMap accessibilityState = (ReadableMap) view.getTag(R.id.accessibility_state);
    final String accessibilityHint = (String) view.getTag(R.id.accessibility_hint);
    final List<String> contentDescription = new ArrayList<>();
    final ReadableMap accessibilityValue = (ReadableMap) view.getTag(R.id.accessibility_value);
    if (accessibilityLabel != null) {
      contentDescription.add(accessibilityLabel);
    }
>>>>>>> fb/0.62-stable
    if (accessibilityState != null) {
      final ReadableMapKeySetIterator i = accessibilityState.keySetIterator();
      while (i.hasNextKey()) {
        final String state = i.nextKey();
        final Dynamic value = accessibilityState.getDynamic(state);
        if (state.equals(STATE_CHECKED)
            && value.getType() == ReadableType.String
            && value.asString().equals(STATE_MIXED)) {
          contentDescription.add(view.getContext().getString(R.string.state_mixed_description));
        } else if (state.equals(STATE_BUSY)
            && value.getType() == ReadableType.Boolean
            && value.asBoolean()) {
          contentDescription.add(view.getContext().getString(R.string.state_busy_description));
        } else if (state.equals(STATE_EXPANDED) && value.getType() == ReadableType.Boolean) {
          contentDescription.add(
              view.getContext()
                  .getString(
                      value.asBoolean()
                          ? R.string.state_expanded_description
                          : R.string.state_collapsed_description));
        }
      }
    }
    if (accessibilityValue != null && accessibilityValue.hasKey("text")) {
      final Dynamic text = accessibilityValue.getDynamic("text");
      if (text != null && text.getType() == ReadableType.String) {
        contentDescription.add(text.asString());
      }
    }
    if (accessibilityHint != null) {
      contentDescription.add(accessibilityHint);
    }
    if (contentDescription.size() > 0) {
      view.setContentDescription(TextUtils.join(", ", contentDescription));
    }
  }

<<<<<<< HEAD
=======
  @Override
>>>>>>> fb/0.62-stable
  @ReactProp(name = ViewProps.ACCESSIBILITY_ACTIONS)
  public void setAccessibilityActions(T view, ReadableArray accessibilityActions) {
    if (accessibilityActions == null) {
      return;
    }

    view.setTag(R.id.accessibility_actions, accessibilityActions);
  }

<<<<<<< HEAD
=======
  @ReactProp(name = ViewProps.ACCESSIBILITY_VALUE)
  public void setAccessibilityValue(T view, ReadableMap accessibilityValue) {
    if (accessibilityValue == null) {
      return;
    }

    view.setTag(R.id.accessibility_value, accessibilityValue);
    if (accessibilityValue.hasKey("text")) {
      updateViewContentDescription(view);
    }
  }

  @Override
>>>>>>> fb/0.62-stable
  @ReactProp(name = ViewProps.IMPORTANT_FOR_ACCESSIBILITY)
  public void setImportantForAccessibility(
      @NonNull T view, @Nullable String importantForAccessibility) {
    if (importantForAccessibility == null || importantForAccessibility.equals("auto")) {
      ViewCompat.setImportantForAccessibility(view, ViewCompat.IMPORTANT_FOR_ACCESSIBILITY_AUTO);
    } else if (importantForAccessibility.equals("yes")) {
      ViewCompat.setImportantForAccessibility(view, ViewCompat.IMPORTANT_FOR_ACCESSIBILITY_YES);
    } else if (importantForAccessibility.equals("no")) {
      ViewCompat.setImportantForAccessibility(view, ViewCompat.IMPORTANT_FOR_ACCESSIBILITY_NO);
    } else if (importantForAccessibility.equals("no-hide-descendants")) {
      ViewCompat.setImportantForAccessibility(
          view, ViewCompat.IMPORTANT_FOR_ACCESSIBILITY_NO_HIDE_DESCENDANTS);
    }
  }

  @Override
  @Deprecated
  @ReactProp(name = ViewProps.ROTATION)
  public void setRotation(@NonNull T view, float rotation) {
    view.setRotation(rotation);
  }

  @Override
  @Deprecated
  @ReactProp(name = ViewProps.SCALE_X, defaultFloat = 1f)
  public void setScaleX(@NonNull T view, float scaleX) {
    view.setScaleX(scaleX);
  }

  @Override
  @Deprecated
  @ReactProp(name = ViewProps.SCALE_Y, defaultFloat = 1f)
  public void setScaleY(@NonNull T view, float scaleY) {
    view.setScaleY(scaleY);
  }

  @Override
  @Deprecated
  @ReactProp(name = ViewProps.TRANSLATE_X, defaultFloat = 0f)
  public void setTranslateX(@NonNull T view, float translateX) {
    view.setTranslationX(PixelUtil.toPixelFromDIP(translateX));
  }

  @Override
  @Deprecated
  @ReactProp(name = ViewProps.TRANSLATE_Y, defaultFloat = 0f)
  public void setTranslateY(@NonNull T view, float translateY) {
    view.setTranslationY(PixelUtil.toPixelFromDIP(translateY));
  }

<<<<<<< HEAD
=======
  @Override
>>>>>>> fb/0.62-stable
  @ReactProp(name = ViewProps.ACCESSIBILITY_LIVE_REGION)
  public void setAccessibilityLiveRegion(@NonNull T view, @Nullable String liveRegion) {
    if (liveRegion == null || liveRegion.equals("none")) {
      ViewCompat.setAccessibilityLiveRegion(view, ViewCompat.ACCESSIBILITY_LIVE_REGION_NONE);
    } else if (liveRegion.equals("polite")) {
      ViewCompat.setAccessibilityLiveRegion(view, ViewCompat.ACCESSIBILITY_LIVE_REGION_POLITE);
    } else if (liveRegion.equals("assertive")) {
      ViewCompat.setAccessibilityLiveRegion(view, ViewCompat.ACCESSIBILITY_LIVE_REGION_ASSERTIVE);
    }
  }

  private static void setTransformProperty(@NonNull View view, ReadableArray transforms) {
<<<<<<< HEAD
=======
    sMatrixDecompositionContext.reset();
>>>>>>> fb/0.62-stable
    TransformHelper.processTransform(transforms, sTransformDecompositionArray);
    MatrixMathHelper.decomposeMatrix(sTransformDecompositionArray, sMatrixDecompositionContext);
    view.setTranslationX(
        PixelUtil.toPixelFromDIP(
            sanitizeFloatPropertyValue((float) sMatrixDecompositionContext.translation[0])));
    view.setTranslationY(
        PixelUtil.toPixelFromDIP(
            sanitizeFloatPropertyValue((float) sMatrixDecompositionContext.translation[1])));
    view.setRotation(
        sanitizeFloatPropertyValue((float) sMatrixDecompositionContext.rotationDegrees[2]));
    view.setRotationX(
        sanitizeFloatPropertyValue((float) sMatrixDecompositionContext.rotationDegrees[0]));
    view.setRotationY(
        sanitizeFloatPropertyValue((float) sMatrixDecompositionContext.rotationDegrees[1]));
    view.setScaleX(sanitizeFloatPropertyValue((float) sMatrixDecompositionContext.scale[0]));
    view.setScaleY(sanitizeFloatPropertyValue((float) sMatrixDecompositionContext.scale[1]));

    double[] perspectiveArray = sMatrixDecompositionContext.perspective;

    if (perspectiveArray.length > PERSPECTIVE_ARRAY_INVERTED_CAMERA_DISTANCE_INDEX) {
      float invertedCameraDistance =
          (float) perspectiveArray[PERSPECTIVE_ARRAY_INVERTED_CAMERA_DISTANCE_INDEX];
      if (invertedCameraDistance == 0) {
        // Default camera distance, before scale multiplier (1280)
        invertedCameraDistance = 0.00078125f;
      }
      float cameraDistance = -1 / invertedCameraDistance;
      float scale = DisplayMetricsHolder.getScreenDisplayMetrics().density;

      // The following converts the matrix's perspective to a camera distance
      // such that the camera perspective looks the same on Android and iOS.
      // The native Android implementation removed the screen density from the
      // calculation, so squaring and a normalization value of
      // sqrt(5) produces an exact replica with iOS.
      // For more information, see https://github.com/facebook/react-native/pull/18302
      float normalizedCameraDistance =
<<<<<<< HEAD
          scale * scale * cameraDistance * CAMERA_DISTANCE_NORMALIZATION_MULTIPLIER;
      view.setCameraDistance(normalizedCameraDistance);
=======
          sanitizeFloatPropertyValue(
              scale * scale * cameraDistance * CAMERA_DISTANCE_NORMALIZATION_MULTIPLIER);
      view.setCameraDistance(normalizedCameraDistance);
    }
  }

  /**
   * Prior to Android P things like setScaleX() allowed passing float values that were bogus such as
   * Float.NaN. If the app is targeting Android P or later then passing these values will result in
   * an exception being thrown. Since JS might still send Float.NaN, we want to keep the code
   * backward compatible and continue using the fallback value if an invalid float is passed.
   */
  private static float sanitizeFloatPropertyValue(float value) {
    if (value >= -Float.MAX_VALUE && value <= Float.MAX_VALUE) {
      return value;
    }
    if (value < -Float.MAX_VALUE || value == Float.NEGATIVE_INFINITY) {
      return -Float.MAX_VALUE;
    }
    if (value > Float.MAX_VALUE || value == Float.POSITIVE_INFINITY) {
      return Float.MAX_VALUE;
>>>>>>> fb/0.62-stable
    }
    if (Float.isNaN(value)) {
      return 0;
    }
    // Shouldn't be possible to reach this point.
    throw new IllegalStateException("Invalid float property value: " + value);
  }

  private static void resetTransformProperty(@NonNull View view) {
    view.setTranslationX(PixelUtil.toPixelFromDIP(0));
    view.setTranslationY(PixelUtil.toPixelFromDIP(0));
    view.setRotation(0);
    view.setRotationX(0);
    view.setRotationY(0);
    view.setScaleX(1);
    view.setScaleY(1);
    view.setCameraDistance(0);
  }

  private void updateViewAccessibility(@NonNull T view) {
    ReactAccessibilityDelegate.setDelegate(view);
  }

  @Override
  protected void onAfterUpdateTransaction(@NonNull T view) {
    super.onAfterUpdateTransaction(view);
    updateViewAccessibility(view);
  }

  @Override
  public @Nullable Map<String, Object> getExportedCustomDirectEventTypeConstants() {
    return MapBuilder.<String, Object>builder()
        .put("topAccessibilityAction", MapBuilder.of("registrationName", "onAccessibilityAction"))
        .build();
  }

<<<<<<< HEAD
  protected void setBorderRadius(T view, float borderRadius) {
    logUnsupportedPropertyWarning(ViewProps.BORDER_RADIUS);
  }

  protected void setBorderBottomLeftRadius(T view, float borderRadius) {
    logUnsupportedPropertyWarning(ViewProps.BORDER_BOTTOM_LEFT_RADIUS);
  }

  protected void setBorderBottomRightRadius(T view, float borderRadius) {
    logUnsupportedPropertyWarning(ViewProps.BORDER_BOTTOM_RIGHT_RADIUS);
  }

  protected void setBorderTopLeftRadius(T view, float borderRadius) {
    logUnsupportedPropertyWarning(ViewProps.BORDER_TOP_LEFT_RADIUS);
  }

  protected void setBorderTopRightRadius(T view, float borderRadius) {
=======
  @Override
  public void setBorderRadius(T view, float borderRadius) {
    logUnsupportedPropertyWarning(ViewProps.BORDER_RADIUS);
  }

  @Override
  public void setBorderBottomLeftRadius(T view, float borderRadius) {
    logUnsupportedPropertyWarning(ViewProps.BORDER_BOTTOM_LEFT_RADIUS);
  }

  @Override
  public void setBorderBottomRightRadius(T view, float borderRadius) {
    logUnsupportedPropertyWarning(ViewProps.BORDER_BOTTOM_RIGHT_RADIUS);
  }

  @Override
  public void setBorderTopLeftRadius(T view, float borderRadius) {
    logUnsupportedPropertyWarning(ViewProps.BORDER_TOP_LEFT_RADIUS);
  }

  @Override
  public void setBorderTopRightRadius(T view, float borderRadius) {
>>>>>>> fb/0.62-stable
    logUnsupportedPropertyWarning(ViewProps.BORDER_TOP_RIGHT_RADIUS);
  }

  private void logUnsupportedPropertyWarning(String propName) {
    FLog.w(ReactConstants.TAG, "%s doesn't support property '%s'", getName(), propName);
  }
}
