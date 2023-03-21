# frozen_string_literal: true

require_relative 'lib/sentencepiece/version'

Gem::Specification.new do |spec|
  spec.name = 'sentencepiece'
  spec.version = SentencePiece::VERSION
  spec.authors = ['yoshoku']
  spec.email = ['yoshoku@outlook.com']

  spec.summary = 'Write a short summary, because RubyGems requires one.'
  spec.description = 'Write a longer description or delete this line.'
  spec.homepage = 'https://github.com/yoshoku/sentencepiece.rb'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.extensions = ['ext/sentencepiece/extconf.rb']
end
