# frozen_string_literal: true

module Views
  # path to posts
  class PathPresenter
    def self.to_post(hashtag_name)
      "/media/#{hashtag_name}"
    end

    # def self.to_folder(owner_name, project_name, folder_path)
    #   "/project/#{owner_name}/#{project_name}/#{folder_path}"
    # end

    def self.path_leaf(path)
      path.split('/').last
    end
  end
end
