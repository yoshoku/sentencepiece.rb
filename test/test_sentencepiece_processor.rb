# frozen_string_literal: true

require 'test_helper'

class TestSentencePieceProcessor < Minitest::Test
  def setup
    @sp = SentencePiece::SentencePieceProcessor.new(model_file: 'test/test_model.model')
    @sp_ja = SentencePiece::SentencePieceProcessor.new(model_file: 'test/test_ja_model.model')
  end

  def test_load
    assert_equal(1000, @sp.piece_size)
    assert_equal(0, @sp.piece_to_id('<unk>'))
    assert_equal(1, @sp.piece_to_id('<s>'))
    assert_equal(2, @sp.piece_to_id('</s>'))
    assert_equal('<unk>', @sp.id_to_piece(0))
    assert_equal('<s>', @sp.id_to_piece(1))
    assert_equal('</s>', @sp.id_to_piece(2))
    assert_equal(0, @sp.unk_id)
    assert_equal(1, @sp.bos_id)
    assert_equal(2, @sp.eos_id)
    assert_equal(-1, @sp.pad_id)
    @sp.piece_size.times do |i|
      piece = @sp.id_to_piece(i)

      assert_equal(i, @sp.piece_to_id(piece))
    end
  end

  def test_ja_load
    assert_equal(8000, @sp_ja.piece_size)
    assert_equal(0, @sp_ja.piece_to_id('<unk>'))
    assert_equal(1, @sp_ja.piece_to_id('<s>'))
    assert_equal(2, @sp_ja.piece_to_id('</s>'))
    assert_equal('<unk>', @sp_ja.id_to_piece(0))
    assert_equal('<s>', @sp_ja.id_to_piece(1))
    assert_equal('</s>', @sp_ja.id_to_piece(2))
    @sp_ja.piece_size.times do |i|
      piece = @sp_ja.id_to_piece(i)

      assert_equal(i, @sp_ja.piece_to_id(piece))
    end
  end
end
