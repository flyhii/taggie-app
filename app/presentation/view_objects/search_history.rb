# rubocop:disable Layout/EndOfLine
# frozen_string_literal: true

module Views
  # View for hashtags search history
  class HistoryViewObject
    def initialize(watching)
      @watching = watching
    end

    def tags
      @watching
    end

    def empty?
      @watching.empty?
    end

    def any?
      @watching.any?
    end
  end
end

# rubocop:enable Layout/EndOfLine
