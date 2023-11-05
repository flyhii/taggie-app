# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:media) do
      primary_key :id
      foreign_key :hashtag_id, :hashtag

      Integer     :media_id, unique: true
      Integer     :like_count
      DateTime    :timestamp
      String      :caption

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
