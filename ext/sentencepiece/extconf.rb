# frozen_string_literal: true

require 'mkmf'

abort 'libstdc++ is not found.' unless have_library('stdc++')
abort 'libsentencepiece is not found.' unless have_library('sentencepiece')
abort 'libsentencepiece_train is not found.' unless have_library('sentencepiece_train')

# abort 'sentencepiece_processor.h is not found.' unless have_header('sentencepiece_processor.h')
# abort 'sentencepiece_trainer.h is not found.' unless have_header('sentencepiece_trainer.h')

$CXXFLAGS << ' -std=c++11'

create_makefile('sentencepiece/sentencepiece')
