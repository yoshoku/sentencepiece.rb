# frozen_string_literal: true

require_relative 'lib/sentencepiece/version'

Gem::Specification.new do |spec|
  spec.name = 'sentencepiece'
  spec.version = SentencePiece::VERSION
  spec.authors = ['yoshoku']
  spec.email = ['yoshoku@outlook.com']

  spec.summary = 'Ruby bindings for the SentencePiece'
  spec.description = <<~MSG
    sentencepiece.rb provides Ruby bindings for the SentencePiece,
    an unsupervised text tokenizer and detokenizer for neural network-based text generation.
  MSG
  spec.homepage = 'https://github.com/yoshoku/sentencepiece.rb'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:(?:test|spec|features)/)}) }
                     .select { |f| f.match(/\.(?:rb|rbs|h|hpp|c|cpp|md|txt)$/) }
  end
  spec.files.delete('ext/sentencepiece/dummy.rb')

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.extensions = ['ext/sentencepiece/extconf.rb']
end
