# rubocop:disable Layout/EndOfLine
# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:hashtags) do
      primary_key :id

      String      :hashtag_name, unique: true, null: false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end

# rubocop:enable Layout/EndOfLine
