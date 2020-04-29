/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 * @format
 */

'use strict';

import type {TurboModule} from '../TurboModule/RCTExport';
import * as TurboModuleRegistry from '../TurboModule/TurboModuleRegistry';
<<<<<<< HEAD
import type {NativeOrDynamicColorType} from '../Color/NativeOrDynamicColorType'; // TODO(macOS ISS#2323203)
=======
>>>>>>> fb/0.62-stable

export interface Spec extends TurboModule {
  +getConstants: () => {||};
  +showActionSheetWithOptions: (
    options: {|
      +title?: ?string,
      +message?: ?string,
      +options: ?Array<string>,
<<<<<<< HEAD
      // Supports Array<number> as well.
      +destructiveButtonIndex?: ?number,
      +cancelButtonIndex?: ?number,
      +anchor?: ?number,
      +tintColor?: ?(number | NativeOrDynamicColorType), // TODO(macOS ISS#2323203)
=======
      +destructiveButtonIndices?: ?Array<number>,
      +cancelButtonIndex?: ?number,
      +anchor?: ?number,
      +tintColor?: ?number,
>>>>>>> fb/0.62-stable
    |},
    callback: (buttonIndex: number) => void,
  ) => void;
  +showShareActionSheetWithOptions: (
    options: {|
      +message?: ?string,
      +url?: ?string,
      +subject?: ?string,
      +anchor?: ?number,
<<<<<<< HEAD
      +tintColor?: ?(number | NativeOrDynamicColorType), // TODO(macOS ISS#2323203)
=======
      +tintColor?: ?number,
>>>>>>> fb/0.62-stable
      +excludedActivityTypes?: ?Array<string>,
    |},
    failureCallback: (error: {|
      +domain: string,
      +code: string,
      +userInfo?: ?Object,
      +message: string,
    |}) => void,
    successCallback: (completed: boolean, activityType: ?string) => void,
  ) => void;
}

export default (TurboModuleRegistry.get<Spec>('ActionSheetManager'): ?Spec);
