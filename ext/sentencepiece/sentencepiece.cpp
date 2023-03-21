/**
 * sentencepiece.rb provides Ruby bindings for the SentencePiece.
 *
 * Copyright (c) 2023 Atsushi Tatsuma
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "sentencepiece.hpp"

extern "C" void Init_sentencepiece(void) {
  rb_mSentencePiece = rb_define_module("SentencePiece");
  rb_eSentencePieceError = rb_define_class_under(rb_mSentencePiece, "Error", rb_eRuntimeError);
  RbSentencePieceProcessor::define_class(rb_mSentencePiece);
}
