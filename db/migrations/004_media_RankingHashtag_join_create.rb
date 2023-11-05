# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:media_RankingHashtag) do
      primary_key [:media_id, :RankingHahstag_id] # rubocop:disable Style/SymbolArray
      foreign_key :media_id, :hashtag
      foreign_key :RankingHahstag_id, :RankingHahstag

      index [:media_id, :RankingHahstag_id] # rubocop:disable Style/SymbolArray
    end
  end
end
