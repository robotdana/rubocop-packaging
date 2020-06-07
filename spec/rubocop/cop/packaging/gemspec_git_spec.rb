# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Packaging::GemspecGit do # rubocop:disable Metrics/BlockLength
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `git` for files=' do
    expect_offense(<<~RUBY)
      Gem::Specification.new do |spec|
        spec.files = `git ls-files`.split("\\n")
                     ^^^^^^^^^^^^^^ Don\'t use git
      end
    RUBY
  end

  it 'registers an offense when using `git` for executables=' do
    expect_offense(<<~RUBY)
      Gem::Specification.new do |spec|
        spec.executables = `git ls-files`.split("\\n")
                           ^^^^^^^^^^^^^^ Don\'t use git
      end
    RUBY
  end

  it 'registers an offense when using `git` for files= with more stuff' do
    expect_offense(<<~RUBY)
      Gem::Specification.new do |spec|
        spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
          `git ls-files -z`.split("\\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
          ^^^^^^^^^^^^^^^^^ Don\'t use git
        end
      end
    RUBY
  end

  it 'does not register an offense not in a specification' do
    expect_no_offenses(<<~RUBY)
      spec.files = `git ls-files`
    RUBY
  end
end
