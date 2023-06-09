# sentencepiece.rb

[![Build Status](https://github.com/yoshoku/sentencepiece.rb/actions/workflows/main.yml/badge.svg)](https://github.com/yoshoku/sentencepiece.rb/actions/workflows/main.yml)
[![Gem Version](https://badge.fury.io/rb/sentencepiece.svg)](https://badge.fury.io/rb/sentencepiece)
[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://github.com/yoshoku/sentencepiece.rb/blob/main/LICENSE.txt)
[![Documentation](https://img.shields.io/badge/api-reference-blue.svg)](https://yoshoku.github.io/sentencepiece.rb/doc/)

sentencepiece.rb provides Ruby bindings for the [SentencePiece](https://github.com/google/sentencepiece),
an unsupervised text tokenizer and detokenizer for neural network-based text generation.

## Installation

Install SentencePiece using your OS package manager;

macOS:

    $ brew install sentencepiece

Ubuntu:

    $ sudo apt-get install sentencepiece libsentencepiece-dev

Install the gem and add to the application's Gemfile by executing:

    $ bundle add setencepiece

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install sentencepiece

If you use homebrew on Apple M1/M2 mac, specify the homebrew installation directory:

    $ gem install sentencepiece -- --with-opt-dir=/opt/homebrew

## Usage

```ruby
require 'sentencepiece'

sp = SentencePiece::SentencePieceProcessor.new(model_file: '/path/to/model_file.model')

sp.encode('This is a test')
# => [17522, 2852, 29, 2002]

sp.encode(['This is a test', 'Hello world'])
# => [[17522, 2852, 29, 2002], [9770, 18905]]

sp.encode('This is a test', out_type: 'str')
# => ["▁This", "▁is", "▁a", "▁test"]

sp.decode([17522, 2852, 29, 2002])
# => "This is a test"

sp.decode([[17522, 2852, 29, 2002], [9770, 18905]])
# => ["This is a test", "Hello world"]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yoshoku/sentencepiece.rb/.
This project is intended to be a safe, welcoming space for collaboration,
and contributors are expected to adhere to the [code of conduct](https://github.com/yoshoku/sentencepiece.rb/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the SentencePiece project's codebases, issue trackers,
chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/yoshoku/sentencepiece.rb/blob/main/CODE_OF_CONDUCT.md).
