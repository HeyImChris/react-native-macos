<<<<<<< HEAD
/**
=======
/*
>>>>>>> fb/0.62-stable
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "RawPropsKey.h"

#include <cassert>
#include <cstring>

#include <react/core/RawPropsPrimitives.h>

namespace facebook {
namespace react {

<<<<<<< HEAD
void RawPropsKey::render(char *buffer, RawPropsPropNameLength *length) const {
=======
void RawPropsKey::render(char *buffer, RawPropsPropNameLength *length) const
    noexcept {
>>>>>>> fb/0.62-stable
  *length = 0;

  // Prefix
  if (prefix) {
    auto prefixLength = std::strlen(prefix);
    std::memcpy(buffer, prefix, prefixLength);
    *length = prefixLength;
  }

  // Name
  auto nameLength = std::strlen(name);
  std::memcpy(buffer + *length, name, nameLength);
  *length += nameLength;

  // Suffix
  if (suffix) {
    int suffixLength = std::strlen(suffix);
    std::memcpy(buffer + *length, suffix, suffixLength);
    *length += suffixLength;
  }
  assert(*length < kPropNameLengthHardCap);
}

<<<<<<< HEAD
RawPropsKey::operator std::string() const {
=======
RawPropsKey::operator std::string() const noexcept {
>>>>>>> fb/0.62-stable
  char buffer[kPropNameLengthHardCap];
  RawPropsPropNameLength length = 0;
  render(buffer, &length);
  assert(length < kPropNameLengthHardCap);
  return std::string{buffer, length};
}

<<<<<<< HEAD
bool operator==(RawPropsKey const &lhs, RawPropsKey const &rhs) {
=======
bool operator==(RawPropsKey const &lhs, RawPropsKey const &rhs) noexcept {
>>>>>>> fb/0.62-stable
  // Note: We check the name first.
  return lhs.name == rhs.name && lhs.prefix == rhs.prefix &&
      lhs.suffix == rhs.suffix;
}

<<<<<<< HEAD
bool operator!=(RawPropsKey const &lhs, RawPropsKey const &rhs) {
=======
bool operator!=(RawPropsKey const &lhs, RawPropsKey const &rhs) noexcept {
>>>>>>> fb/0.62-stable
  return !(lhs == rhs);
}

} // namespace react
} // namespace facebook
