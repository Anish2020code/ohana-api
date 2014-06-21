module Api
  module V1
    class FaxesController < ApplicationController
      include TokenValidator

      before_action :validate_token!, only: [:update, :destroy, :create]

      def update
        fax = Fax.find(params[:id])
        fax.update!(params)
        render json: fax, status: 200
      end

      def create
        location = Location.find(params[:location_id])
        fax = location.faxes.create!(params)
        render json: fax, status: 201
      end

      def destroy
        fax = Fax.find(params[:id])
        fax.destroy
        head 204
      end
    end
  end
end
