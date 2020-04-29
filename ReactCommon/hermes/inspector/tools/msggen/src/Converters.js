/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
<<<<<<< HEAD
 * @flow
 * @format
 */
=======
 * @flow strict-local
 * @format
 */

>>>>>>> fb/0.62-stable
'use strict';

export function toCppNamespace(domain: string): string {
  return domain.substr(0, 1).toLowerCase() + domain.substr(1);
}

export function toCppType(type: string): string {
  return type.substr(0, 1).toUpperCase() + type.substr(1);
}

<<<<<<< HEAD
const jsTypeMappings: {[key: string]: string} = {
=======
const jsTypeMappings: {[key: string]: string, ...} = {
>>>>>>> fb/0.62-stable
  any: 'folly::dynamic',
  array: 'folly::dynamic',
  boolean: 'bool',
  integer: 'int',
  number: 'double',
  object: 'folly::dynamic',
  string: 'std::string',
};

export function jsTypeToCppType(jsTypeStr: string): string {
  const cppType = jsTypeMappings[jsTypeStr];
  if (!cppType) {
    throw new TypeError(`${jsTypeStr} is not an expected JS type string`);
  }
  return cppType;
}
