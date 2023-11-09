# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:media) do
      primary_key :id

      String      :media_id, unique: true
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
