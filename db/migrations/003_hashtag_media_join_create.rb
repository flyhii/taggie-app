# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:hashtag_media) do
      primary_key [:hashtag_id, :media_id] # rubocop:disable Style/SymbolArray
      foreign_key :hashtag_id, :hashtag
      foreign_key :media_id, :media

      index [:hashtag_id, :media_id] # rubocop:disable Style/SymbolArray
    end
  end
end