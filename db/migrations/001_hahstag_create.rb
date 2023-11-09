# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:hashtag) do
      primary_key :id

      String      :api_id, unique: true
      String      :hashtag_name, unique: true, null: false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
