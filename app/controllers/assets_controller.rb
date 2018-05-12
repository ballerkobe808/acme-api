class AssetsController < ApplicationController
  def index

    # RefreshCoinsJob.perform_later

    assets = Asset.all
    render json: assets
  end
end
