/**
 * sentencepiece.rb is a Ruby binding for the SentencePiece.
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

#ifndef SENTENCEPIECE_HPP
#define SENTENCEPIECE_HPP 1

#include <sentencepiece_processor.h>
#include <sentencepiece_trainer.h>

#include <ruby.h>

VALUE rb_mSentencePiece;
VALUE rb_eSentencePieceError;
VALUE rb_cSentencePieceProcessor;

class RbSentencePieceProcessor {
public:
  static VALUE sentencepiece_processor_alloc(VALUE self) {
    sentencepiece::SentencePieceProcessor* ptr = (sentencepiece::SentencePieceProcessor*)ruby_xmalloc(sizeof(sentencepiece::SentencePieceProcessor));
    new (ptr) sentencepiece::SentencePieceProcessor();
    return TypedData_Wrap_Struct(self, &sentencepiece_processor_type, ptr);
  };

  static void sentencepiece_processor_free(void* ptr) {
    ((sentencepiece::SentencePieceProcessor*)ptr)->~SentencePieceProcessor();
    ruby_xfree(ptr);
  };

  static size_t sentencepiece_processor_size(const void* ptr) {
    return sizeof(*((sentencepiece::SentencePieceProcessor*)ptr));
  };

  static sentencepiece::SentencePieceProcessor* get_sentencepiece_processor(VALUE self) {
    sentencepiece::SentencePieceProcessor* ptr;
    TypedData_Get_Struct(self, sentencepiece::SentencePieceProcessor, &sentencepiece_processor_type, ptr);
    return ptr;
  };

  static VALUE define_class(VALUE outer) {
    rb_cSentencePieceProcessor = rb_define_class_under(outer, "SentencePieceProcessor", rb_cObject);
    rb_define_alloc_func(rb_cSentencePieceProcessor, sentencepiece_processor_alloc);
    rb_define_method(rb_cSentencePieceProcessor, "initialize", RUBY_METHOD_FUNC(_sentencepiece_processor_init), 0);
    rb_define_method(rb_cSentencePieceProcessor, "load", RUBY_METHOD_FUNC(_sentencepiece_processor_load), 1);
    rb_define_method(rb_cSentencePieceProcessor, "encode", RUBY_METHOD_FUNC(_sentencepiece_processor_encode), -1);
    rb_define_method(rb_cSentencePieceProcessor, "decode", RUBY_METHOD_FUNC(_sentencepiece_processor_decode), -1);
    rb_define_method(rb_cSentencePieceProcessor, "piece_size", RUBY_METHOD_FUNC(_sentencepiece_processor_piece_size), 0);
    rb_define_method(rb_cSentencePieceProcessor, "piece_to_id", RUBY_METHOD_FUNC(_sentencepiece_processor_piece_to_id), 1);
    rb_define_method(rb_cSentencePieceProcessor, "id_to_piece", RUBY_METHOD_FUNC(_sentencepiece_processor_id_to_piece), 1);
    return rb_cSentencePieceProcessor;
  };

private:
  static const rb_data_type_t sentencepiece_processor_type;

  static VALUE _sentencepiece_processor_init(VALUE self) {
    sentencepiece::SentencePieceProcessor* ptr = get_sentencepiece_processor(self);
    new (ptr) sentencepiece::SentencePieceProcessor();
    return Qnil;
  };

  static VALUE _sentencepiece_processor_load(VALUE self, VALUE model_path) {
    sentencepiece::SentencePieceProcessor* ptr = get_sentencepiece_processor(self);
    sentencepiece::util::Status status = ptr->Load(StringValueCStr(model_path));
    if (!status.ok()) {
      rb_raise(rb_eSentencePieceError, "%s", status.message());
      return Qfalse;
    }
    return Qtrue;
  };

  static VALUE _sentencepiece_processor_encode(int argc, VALUE* argv, VALUE self) {
    VALUE kw_args = Qnil;
    ID kw_table[1] = { rb_intern("out_type") };
    VALUE kw_values[1] = { Qundef };

    VALUE text = Qnil;
    rb_scan_args(argc, argv, "1:", &text, &kw_args);
    rb_get_kwargs(kw_args, kw_table, 0, 1, kw_values);
    VALUE out_type = kw_values[0] != Qundef ? kw_values[0] : rb_str_new_cstr("int");

    if (!RB_TYPE_P(out_type, T_STRING)) {
      rb_raise(rb_eArgError, "expected out_type to be a String");
      return Qnil;
    }
    if (strcmp(StringValueCStr(out_type), "str") != 0 && strcmp(StringValueCStr(out_type), "int") != 0) {
      rb_raise(rb_eArgError, "expected out_type to be 'str' or 'id'");
      return Qnil;
    }
    if (!RB_TYPE_P(text, T_STRING) && !RB_TYPE_P(text, T_ARRAY)) {
      rb_raise(rb_eArgError, "expected text to be a String or an Array");
      return Qnil;
    }

    VALUE output = rb_ary_new();
    sentencepiece::SentencePieceProcessor* ptr = get_sentencepiece_processor(self);
    if (RB_TYPE_P(text, T_STRING)) {
      if (strcmp(StringValueCStr(out_type), "str") == 0) {
        std::vector<std::string> pieces;
        sentencepiece::util::Status status = ptr->Encode(StringValueCStr(text), &pieces);
        if (!status.ok()) {
          rb_raise(rb_eSentencePieceError, "%s", status.message());
          return Qnil;
        }
        for (const std::string& token : pieces) {
          rb_ary_push(output, rb_utf8_str_new_cstr(token.c_str()));
        }
      } else {
        std::vector<int> ids;
        sentencepiece::util::Status status = ptr->Encode(StringValueCStr(text), &ids);
        if (!status.ok()) {
          rb_raise(rb_eSentencePieceError, "%s", status.message());
          return Qnil;
        }
        for (const int idx : ids) {
          rb_ary_push(output, INT2NUM(idx));
        }
      }
    } else {
      const size_t n_text = RARRAY_LEN(text);
      if (strcmp(StringValueCStr(out_type), "str") == 0) {
        for (size_t i = 0; i < n_text; i++) {
          VALUE sub_text = rb_ary_entry(text, i);
          std::vector<std::string> pieces;
          sentencepiece::util::Status status = ptr->Encode(StringValueCStr(sub_text), &pieces);
          if (!status.ok()) {
            rb_raise(rb_eSentencePieceError, "%s", status.message());
            return Qnil;
          }
          VALUE sub_output = rb_ary_new();
          for (const std::string& token : pieces) {
            rb_ary_push(sub_output, rb_utf8_str_new_cstr(token.c_str()));
          }
          rb_ary_push(output, sub_output);
        }
      } else {
        for (size_t i = 0; i < n_text; i++) {
          VALUE sub_text = rb_ary_entry(text, i);
          std::vector<int> ids;
          sentencepiece::util::Status status = ptr->Encode(StringValueCStr(sub_text), &ids);
          if (!status.ok()) {
            rb_raise(rb_eSentencePieceError, "%s", status.message());
            return Qnil;
          }
          VALUE sub_output = rb_ary_new();
          for (const int idx : ids) {
            rb_ary_push(sub_output, INT2NUM(idx));
          }
          rb_ary_push(output, sub_output);
        }
      }
    }

    RB_GC_GUARD(out_type);
    RB_GC_GUARD(text);

    return output;
  };

  static VALUE _sentencepiece_processor_decode(int argc, VALUE* argv, VALUE self) {
    VALUE kw_args = Qnil;
    ID kw_table[1] = { rb_intern("out_type") };
    VALUE kw_values[1] = { Qundef };

    VALUE pieces = Qnil;
    rb_scan_args(argc, argv, "1:", &pieces, &kw_args);
    rb_get_kwargs(kw_args, kw_table, 0, 1, kw_values);
    VALUE out_type = kw_values[0] != Qundef ? kw_values[0] : rb_str_new_cstr("int");

    if (!RB_TYPE_P(pieces, T_ARRAY)) {
      rb_raise(rb_eArgError, "expected out_type to be an Array");
      return Qnil;
    }
    if (strcmp(StringValueCStr(out_type), "str") != 0 && strcmp(StringValueCStr(out_type), "int") != 0) {
      rb_raise(rb_eArgError, "expected out_type to be 'str' or 'id'");
      return Qnil;
    }

    const size_t n_pieces = RARRAY_LEN(pieces);
    if (n_pieces == 0) return rb_str_new_cstr("");

    VALUE output = Qnil;
    sentencepiece::SentencePieceProcessor* ptr = get_sentencepiece_processor(self);
    const size_t n_dimensions = RB_TYPE_P(rb_ary_entry(pieces, 0), T_ARRAY) ? 2 : 1;

    if (strcmp(StringValueCStr(out_type), "str") == 0) {
      if (n_dimensions == 1) {
        std::vector<std::string> pcs;
        for (size_t i = 0; i < n_pieces; i++) {
          VALUE et = rb_ary_entry(pieces, i);
          pcs.push_back(StringValueCStr(et));
        }
        std::string text;
        sentencepiece::util::Status status = ptr->Decode(pcs, &text);
        if (!status.ok()) {
          rb_raise(rb_eSentencePieceError, "%s", status.message());
          return Qfalse;
        }
        output = rb_str_new_cstr(text.c_str());
      } else {
        output = rb_ary_new();
        for (size_t i = 0; i < n_pieces; i++) {
          VALUE sub_pieces = rb_ary_entry(pieces, i);
          const size_t n_sub_pieces = RARRAY_LEN(sub_pieces);
          std::vector<std::string> pcs;
          for (size_t j = 0; j < n_sub_pieces; j++) {
            VALUE et = rb_ary_entry(sub_pieces, j);
            pcs.push_back(StringValueCStr(et));
          }
          std::string text;
          sentencepiece::util::Status status = ptr->Decode(pcs, &text);
          if (!status.ok()) {
            rb_raise(rb_eSentencePieceError, "%s", status.message());
            return Qfalse;
          }
          rb_ary_push(output, rb_str_new_cstr(text.c_str()));
        }
      }
    } else {
      if (n_dimensions == 1) {
        std::vector<int> pcs;
        for (size_t i = 0; i < n_pieces; i++) {
          VALUE et = rb_ary_entry(pieces, i);
          pcs.push_back(NUM2INT(et));
        }
        std::string text;
        sentencepiece::util::Status status = ptr->Decode(pcs, &text);
        if (!status.ok()) {
          rb_raise(rb_eSentencePieceError, "%s", status.message());
          return Qfalse;
        }
        output = rb_str_new_cstr(text.c_str());
      } else {
        output = rb_ary_new();
        for (size_t i = 0; i < n_pieces; i++) {
          VALUE sub_pieces = rb_ary_entry(pieces, i);
          const size_t n_sub_pieces = RARRAY_LEN(sub_pieces);
          std::vector<int> pcs;
          for (size_t j = 0; j < n_sub_pieces; j++) {
            VALUE et = rb_ary_entry(sub_pieces, j);
            pcs.push_back(NUM2INT(et));
          }
          std::string text;
          sentencepiece::util::Status status = ptr->Decode(pcs, &text);
          if (!status.ok()) {
            rb_raise(rb_eSentencePieceError, "%s", status.message());
            return Qfalse;
          }
          rb_ary_push(output, rb_str_new_cstr(text.c_str()));
        }
      }
    }

    return output;
  };

  static VALUE _sentencepiece_processor_piece_size(VALUE self) {
    sentencepiece::SentencePieceProcessor* ptr = get_sentencepiece_processor(self);
    return INT2NUM(ptr->GetPieceSize());
  };

  static VALUE _sentencepiece_processor_piece_to_id(VALUE self, VALUE piece) {
    if (!RB_TYPE_P(piece, T_STRING) && !RB_TYPE_P(piece, T_ARRAY)) {
      rb_raise(rb_eArgError, "expected piece to be a String or an Array");
      return Qnil;
    }
    VALUE output = Qnil;
    sentencepiece::SentencePieceProcessor* ptr = get_sentencepiece_processor(self);
    if (RB_TYPE_P(piece, T_STRING)) {
      const int id = ptr->PieceToId(StringValueCStr(piece));
      output = INT2NUM(id);
    } else {
      const size_t n_pieces = RARRAY_LEN(piece);
      output = rb_ary_new();
      for (size_t i = 0; i < n_pieces; i++) {
        VALUE et = rb_ary_entry(piece, i);
        const int id = ptr->PieceToId(StringValueCStr(et));
        rb_ary_push(output, INT2NUM(id));
      }
    }
    return output;
  };

  static VALUE _sentencepiece_processor_id_to_piece(VALUE self, VALUE ids) {
    if (!RB_INTEGER_TYPE_P(ids) && !RB_TYPE_P(ids, T_ARRAY)) {
      rb_raise(rb_eArgError, "expected piece to be an Integer or an Array");
      return Qnil;
    }
    VALUE output = Qnil;
    sentencepiece::SentencePieceProcessor* ptr = get_sentencepiece_processor(self);
    if (RB_INTEGER_TYPE_P(ids)) {
      const std::string piece = ptr->IdToPiece(NUM2INT(ids));
      output = rb_utf8_str_new_cstr(piece.c_str());
    } else {
      const size_t n_ids = RARRAY_LEN(ids);
      output = rb_ary_new();
      for (size_t i = 0; i < n_ids; i++) {
        VALUE et = rb_ary_entry(ids, i);
        const std::string piece = ptr->IdToPiece(NUM2INT(et));
        rb_ary_push(output, rb_utf8_str_new_cstr(piece.c_str()));
      }
    }
    return output;
  };
};

const rb_data_type_t RbSentencePieceProcessor::sentencepiece_processor_type = {
  "RbSentencePieceProcessor",
  { NULL,
    RbSentencePieceProcessor::sentencepiece_processor_free,
    RbSentencePieceProcessor::sentencepiece_processor_size },
  NULL,
  NULL,
  RUBY_TYPED_FREE_IMMEDIATELY
};

#endif /* SENTENCEPIECE_HPP */
