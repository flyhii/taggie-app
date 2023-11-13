# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
  # Deliberately :reek:DuplicateMethodCall on App.DB
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    FlyHii::App.db.run('PRAGMA foreign_keys = OFF')
    FlyHii::Database::HashtagOrm.map(&:destroy)
    FlyHii::Database::MediaOrm.map(&:destroy)
    FlyHii::App.db.run('PRAGMA foreign_keys = ON')
  end
end
