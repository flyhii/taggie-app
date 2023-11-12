# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

# require_relative 'contributor'

module FlyHii
  module Entity
    # Entity for a one line of code from a contributor
    class HashtagRanking

      attr_reader :contributor, :code, :time, :number

      def initialize(contributor:, code:, time:, number:)
        @contributor = contributor
        @code = code
        @time = time
        @number = number
      end

      def credit
        code.useless? ? NO_CREDIT : FULL_CREDIT
      end
    end
  end
end
