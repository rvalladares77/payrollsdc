class Api::V1::CsvImportsController < ApplicationController

  def create
    errors = WorkLogImporterService.new(params[:file]).create
    
    if errors.empty?
      render succesfull_message
    else
      render error_message(errors)
    end
  end

  private


    def succesfull_message
      { json: { message: 'File uploaded successfully'} , status: :created }
    end

    def error_message(errors)
      { json: { error: 'There were some problem while uploading the csv.', details: errors}, status: :unprocessable_entity }
    end
end
