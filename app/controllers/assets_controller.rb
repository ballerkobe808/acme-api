class AssetsController < ApplicationController
  def index

    assets = Asset.all
    
    render json: all_assets
  end
end
