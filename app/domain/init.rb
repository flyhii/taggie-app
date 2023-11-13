# frozen_string_literal: true

folders = %w[posts rank]
folders.each do |folder|
  require_relative "#{folder}/init"
end
