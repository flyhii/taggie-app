# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:projects) do
      primary_key :id
      foreign_key :media_id, :media

      String      :caption_hashtagName
      Integer     :count

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
