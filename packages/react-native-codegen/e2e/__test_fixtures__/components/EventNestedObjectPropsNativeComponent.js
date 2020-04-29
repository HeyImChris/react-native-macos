/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @format
<<<<<<< HEAD
 * @flow
=======
 * @flow strict-local
>>>>>>> fb/0.62-stable
 */

'use strict';

import type {
  Int32,
  BubblingEventHandler,
  WithDefault,
} from '../../../../../Libraries/Types/CodegenTypes';
import type {ViewProps} from '../../../../../Libraries/Components/View/ViewPropTypes';
import codegenNativeComponent from '../../../../../Libraries/Utilities/codegenNativeComponent';
<<<<<<< HEAD
import {type NativeComponentType} from '../../../../../Libraries/Utilities/codegenNativeComponent';

type OnChangeEvent = $ReadOnly<{|
  location: {
    source: {
      url: string,
    },
    x: Int32,
    y: Int32,
=======
import type {HostComponent} from '../../../../../Libraries/Renderer/shims/ReactNativeTypes';

type OnChangeEvent = $ReadOnly<{|
  location: {
    source: {url: string, ...},
    x: Int32,
    y: Int32,
    ...
>>>>>>> fb/0.62-stable
  },
|}>;

type NativeProps = $ReadOnly<{|
  ...ViewProps,

  // Props
  disabled?: WithDefault<boolean, false>,

  // Events
  onChange?: ?BubblingEventHandler<OnChangeEvent>,
|}>;

export default (codegenNativeComponent<NativeProps>(
  'EventNestedObjectPropsNativeComponentView',
<<<<<<< HEAD
): NativeComponentType<NativeProps>);
=======
): HostComponent<NativeProps>);
>>>>>>> fb/0.62-stable
