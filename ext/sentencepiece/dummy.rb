# frozen_string_literal: true

# The following code is dummy for document generation.

module SentencePiece
  # Runtime error class for wrapping exceptions thrown from SentencePiece.
  #
  # @example
  #   require 'sentencepiece'
  #
  #   sp = SentencePiece::SentencePieceProcessor.new
  #
  #   begin
  #     sp.load('/no/such/file.model')
  #   rescue SentencePiece::Error => e
  #     puts e.message
  #   end
  #
  #   # => "/no/such/file.model": No such file or directory Error #2
  class Error < RuntimeError; end

  # This class is a wrapper of SentencePieceTrainer class in SentencePiece.
  # For more information about train method arguments, see the following link:
  # https://github.com/google/sentencepiece#train-sentencepiece-model
  #
  # @example
  #   require 'sentencepiece'
  #
  #   SentencePiece::SentencePieceTrainer.train(
  #     '--input=corpus.txt --model_prefix=m --vocab_size=1000'
  #   )
  #
  class SentencePieceTrainer
    # Trains a SentencePiece model.
    #
    # @param args [String] The arguments for training.
    # @return [Nil]
    # @raise [SentencePiece::Error]
    def self.train(args); end
  end

  # This class is a wrapper of SentencePieceProcessor class in SentencePiece.
  #
  # @example
  #  require 'sentencepiece'
  #
  #  sp = SentencePiece::SentencePieceProcessor.new(model_file: '/path/to/model_file.model')
  #
  #  sp.encode('Hello world!')
  #  # => [151, 88, 21, 887, 147]
  #
  #  sp.decode([151, 88, 21, 887, 147])
  #  # => "Hello world!"
  class SentencePieceProcessor
    # Creates a new SentencePieceProcessor instance.
    #
    # @param model_file [String] The path to the model file.
    # @return [SentencePieceProcessor]
    # @raise [SentencePiece::Error]
    def initialize(model_file: nil); end

    # Loads a SentencePiece model.
    #
    # @param model_file [String] The path to the model file.
    # @raise [SentencePiece::Error]
    def load(model_file); end

    # Encodes a text into a list of ids or sentence pieces.
    #
    # @param text [String/Array<String>] The text to encode.
    # @param out_type [String] The output type ('int' or 'str').
    # @return [Array<Integer>/Array<String>]
    # @raise [SentencePiece::Error]
    def encode(text, out_type: 'int'); end

    # Encodes a text into a list of ids.
    #
    # @param text [String] The text to encode.
    # @return [Array<Integer>]
    def encode_as_ids(text); end

    # Encodes a text into a list of sentence pieces.
    #
    # @param text [String] The text to encode.
    # @return [Array<String>]
    def encode_as_pieces(text); end

    # Encodes a text into a serialized proto.
    #
    # @param text [String] The text to encode.
    # @return [String]
    def encode_as_serialized_proto(text); end

    # Encodes a text into a list of ids with nbest results.
    #
    # @param text [String] The text to encode.
    # @param nbest_size [Integer] The nbest size.
    # @return [Array<Integer>]
    def nbest_encode_as_ids(text, nbest_size:); end

    # Encodes a text into a list of sentence pieces with nbest results.
    #
    # @param text [String] The text to encode.
    # @param nbest_size [Integer] The nbest size.
    # @return [Array<String>]
    def nbest_encode_as_pieces(text, nbest_size:); end

    # Encodes a text into a serialized proto with nbest results.
    #
    # @param text [String] The text to encode.
    # @param nbest_size [Integer] The nbest size.
    # @return [String]
    def nbest_encode_as_serialized_proto(text, nbest_size:); end

    # Encodes a text into a list of ids by sampling mode.
    #
    # @param text [String] The text to encode.
    # @param nbest_size [Integer] The nbest size.
    # @param alpha [Float] The smoothing parameter.
    # @return [Array<Integer>]
    def sample_encode_as_ids(text, nbest_size:, alpha:); end

    # Encodes a text into a list of sentence pieces by sampling mode.
    #
    # @param text [String] The text to encode.
    # @param nbest_size [Integer] The nbest size.
    # @param alpha [Float] The smoothing parameter.
    # @return [Array<String>]
    def sample_encode_as_pieces(text, nbest_size:, alpha:); end

    # Encodes a text into a serialized proto by sampling mode.
    #
    # @param text [String] The text to encode.
    # @param nbest_size [Integer] The nbest size.
    # @param alpha [Float] The smoothing parameter.
    # @return [String]
    def sample_encode_as_serialized_proto(text, nbest_size:, alpha:); end

    # Decodes a list of ids or sentence pieces into a text.
    #
    # @param ids [Array<Integer>/Array<String>] The ids or sentence pieces to decode.
    # @param out_type [String] The output type ('int' or 'str').
    # @return [String]
    # @raise [SentencePiece::Error]
    def decode(ids, out_type: 'int'); end

    # Decodes a list of ids into a text.
    #
    # @param ids [Array<Integer>] The ids to decode.
    # @return [String]
    def decode_ids(ids); end

    # Decodes a list of ids into a serialized proto.
    #
    # @param ids [Array<Integer>] The ids to decode.
    # @return [String]
    def decode_ids_as_serialized_proto(ids); end

    # Decodes a list of sentence pieces into a text.
    #
    # @param pieces [Array<String>] The sentence pieces to decode.
    # @return [String]
    def decode_pieces(pieces); end

    # Decodes a list of sentence pieces into a serialized proto.
    #
    # @param pieces [Array<String>] The sentence pieces to decode.
    # @return [String]
    def decode_pieces_as_serialized_proto(pieces); end

    # Returns the string representation of vocab id.
    #
    # @param id [Integer] The id to convert.
    # @return [String]
    def id_to_piece(id); end

    # Returns the vocab id of the sentence piece.
    #
    # @param piece [String] The sentence piece to convert.
    # @return [Integer]
    def piece_to_id(piece); end

    # Returns the number of sentence pieces.
    #
    # @return [Integer]
    def piece_size(); end

    # Returns unknown (<unk>) id.
    #
    # @return [Integer]
    def unk_id(); end

    # Returns BOS (<s>) id.
    #
    # @return [Integer]
    def bos_id(); end

    # Returns EOS (</s>) id.
    def eos_id(); end

    # Returns PAD (<pad>) id.
    def pad_id(); end
  end
end
