require 'rails_helper'

RSpec.describe WorkLogImporter do
  describe '#perform' do
    let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'time-report-42.csv')) }

    context 'when the CSV import is valid' do
      it 'returns success message and status' do
        wl_importer = WorkLogImporter.new(file)

        pp wl_importer.perform


        # expect(subject).to eq([{ message: 'File uploaded successfully' }, :created])
      end
    end
  end
end
