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
    @sp.piece_size.times { |i| assert_equal(i, @sp.piece_to_id(@sp.id_to_piece(i))) }
  end

  def test_ja_load
    assert_equal(8000, @sp_ja.piece_size)
    assert_equal(0, @sp_ja.piece_to_id('<unk>'))
    assert_equal(1, @sp_ja.piece_to_id('<s>'))
    assert_equal(2, @sp_ja.piece_to_id('</s>'))
    assert_equal('<unk>', @sp_ja.id_to_piece(0))
    assert_equal('<s>', @sp_ja.id_to_piece(1))
    assert_equal('</s>', @sp_ja.id_to_piece(2))
    @sp_ja.piece_size.times { |i| assert_equal(i, @sp_ja.piece_to_id(@sp_ja.id_to_piece(i))) }
  end

  def test_roundtrip
    text = 'I saw a girl with a telescope.'
    ids = @sp.encode_as_ids(text)
    pieces1 = @sp.encode_as_pieces(text)
    pieces2 = @sp.nbest_encode_as_pieces(text, nbest_size: 10)[0]

    assert_equal(pieces1, pieces2)
    assert_equal(text, @sp.decode_pieces(pieces1))
    assert_equal(text, @sp.decode_ids(ids))
    assert_equal(text, @sp.decode_pieces(@sp.sample_encode_as_pieces(text, nbest_size: 64, alpha: 0.5)))
    assert_equal(text, @sp.decode_pieces(@sp.sample_encode_as_pieces(text, nbest_size: -1, alpha: 0.5)))
    assert_equal(text, @sp.decode_ids(@sp.sample_encode_as_ids(text, nbest_size: 64, alpha: 0.5)))
    assert_equal(text, @sp.decode_ids(@sp.sample_encode_as_ids(text, nbest_size: -1, alpha: 0.5)))
  end

  def test_ja_roundtrip
    text = '清水寺は京都にある。'
    ids = @sp_ja.encode_as_ids(text)
    pieces1 = @sp_ja.encode_as_pieces(text)
    pieces2 = @sp_ja.nbest_encode_as_pieces(text, nbest_size: 10)[0]

    assert_equal(pieces1, pieces2)
    assert_equal(text, @sp_ja.decode_pieces(pieces1))
    assert_equal(text, @sp_ja.decode_ids(ids))
    assert_equal(text, @sp_ja.decode_pieces(@sp_ja.sample_encode_as_pieces(text, nbest_size: 64, alpha: 0.5)))
    assert_equal(text, @sp_ja.decode_pieces(@sp_ja.sample_encode_as_pieces(text, nbest_size: -1, alpha: 0.5)))
  end

  def test_serialized_proto
    text = 'I saw a girl with a telescope.'

    refute_equal('', @sp.encode_as_serialized_proto(text))
    refute_equal('', @sp.sample_encode_as_serialized_proto(text, nbest_size: 10, alpha: 0.2))
    refute_equal('', @sp.nbest_encode_as_serialized_proto(text, nbest_size: 10))
    refute_equal('', @sp.decode_pieces_as_serialized_proto(%w[foo bar]))
    refute_equal('', @sp.decode_ids_as_serialized_proto([20, 30]))
  end
end
