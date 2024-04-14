class Api::V1::CsvImportsController < ApplicationController

  def create
    errors = WorkLogImporter.new(params[:file]).create
    
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

    def error_message(error)
      { json: { error: 'Some employees were not found', not_found_employees: error}, status: :unprocessable_entity }
    end
end
