# frozen_string_literal: true

# TODO: when finished, run `rake generate_cops_documentation` to update the docs
module RuboCop
  module Cop
    module Packaging
      # TODO: Write cop description and example of bad / good code. For every
      # `SupportedStyle` and unique configuration, there needs to be examples.
      # Examples must have valid Ruby syntax. Do not use upticks.
      #
      # @example EnforcedStyle: bar (default)
      #   # Description of the `bar` style.
      #
      #   # bad
      #   bad_bar_method
      #
      #   # bad
      #   bad_bar_method(args)
      #
      #   # good
      #   good_bar_method
      #
      #   # good
      #   good_bar_method(args)
      #
      # @example EnforcedStyle: foo
      #   # Description of the `foo` style.
      #
      #   # bad
      #   bad_foo_method
      #
      #   # bad
      #   bad_foo_method(args)
      #
      #   # good
      #   good_foo_method
      #
      #   # good
      #   good_foo_method(args)
      #
      class GemspecGit < Cop
        MSG = "Don't use git"

        def_node_search :xstr, <<~PATTERN
          (block
            (send
              (const
                (const {cbase nil?} :Gem) :Specification) :new)
            (args
              (arg _)) `$(xstr (str #starts_with_git?)))
        PATTERN

        def investigate(processed_source)
          xstr(processed_source.ast).each do |node|
            add_offense(
              processed_source.ast,
              location: node.loc.expression,
              message: MSG
            )
          end
        end

        def starts_with_git?(str)
          str.start_with?('git')
        end
      end
    end
  end
end
