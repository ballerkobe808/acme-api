class AssetsController < ApplicationController


  # grab all the assets and all their related info
  def index
    assets = Asset.all
    render json: assets
  end

  # grab an asset by its base symbol
  def show
    asset = Asset.where(altbase: params[:id])
    render json: asset
  end
end
