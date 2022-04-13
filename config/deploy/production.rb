# frozen_string_literal: true

set :deploy_to, "/home/etienne/gather"
role :app, %w[etienne@159.203.1.5]
role :web, %w[etienne@159.203.1.5]
role :db,  %w[etienne@159.203.1.5]
set :branch, "develop"
set :rails_env, "production"
set :linked_files, fetch(:linked_files, []).push(".rbenv-vars", "config/settings.local.yml")
