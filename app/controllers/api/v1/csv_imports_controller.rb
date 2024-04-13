class Api::V1::CsvImportsController < ApplicationController
  def create
    work_log_importer = WorkLogImporter.new(params[:file])
    response, status = work_log_importer.create


    render json: response, status: status
  end

  private


    def csv_import_params


    end
end
