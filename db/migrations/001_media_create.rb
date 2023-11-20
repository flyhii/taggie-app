# rubocop:disable Layout/EndOfLine
# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:posts) do
      primary_key :id

      String      :caption
      Integer     :like_count
      Integer     :comments_count
      String      :media_url
      DateTime    :timestamp

      DateTime :created_at
      DateTime :updated_at
    end
  end
end

# rubocop:enable Layout/EndOfLine
