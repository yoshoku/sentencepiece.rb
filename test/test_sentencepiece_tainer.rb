# frozen_string_literal: true

require 'test_helper'

class TestSentencePieceTrainer < Minitest::Test
  def setup; end

  def test_train
    filepath = File.expand_path("#{__dir__}/../LICENSE.txt")
    SentencePiece::SentencePieceTrainer.train("--input=#{filepath} --model_prefix=m --vocab_size=552")
    sp = SentencePiece::SentencePieceProcessor.new
    sp.load('m.model')

    File.open(filepath, 'r').readlines.map(&:strip).each do |line|
      assert_equal(line, sp.decode_pieces(sp.encode_as_pieces(line)))
    end
  end
end
