

describe Eversign::Models::File do

  describe 'valid?' do
    let(:obj) { Eversign::Models::File.new('test') }

    context 'when object is valid' do
      context 'only file_id is set' do
        it 'returns true' do
          obj.file_id = 'test_id'
          expect(obj.valid?).to be true
        end
      end

      context 'only file_url is set' do
        it 'returns true' do
          obj.file_url = 'test_url'
          expect(obj.valid?).to be true
        end
      end

      context 'only file_base64 is set' do
        it 'returns true' do
          obj.file_base64 = 'test_file_base64'
          expect(obj.valid?).to be true
        end
      end
    end

    # context 'when object is not valid' do
    #   context 'file_url and file_id is set' do
    #     it 'returns false' do
    #       obj.file_id = 'test_id'
    #       obj.file_url = 'test_url'
    #       obj.valid?
    #       expect(obj.errors).to include(/Please provide only one file option/)
    #     end
    #   end

    #   context 'only file_url and file_base64 is set' do
    #     it 'returns true' do
    #       obj.file_url = 'test_url'
    #       obj.file_base64 = 'test_file_base64'
    #       expect(obj.valid?).to be false
    #     end
    #   end

    #   context 'only file_id and file_base64 is set' do
    #     it 'returns true' do
    #       obj.file_id = 'test_id'
    #       obj.file_base64 = 'test_file_base64'
    #       expect(obj.valid?).to be false
    #     end
    #   end

    #   context 'only file_id file_url and file_base64 is set' do
    #     it 'returns true' do
    #       obj.file_id = 'test_id'
    #       obj.file_url = 'test_url'
    #       obj.file_base64 = 'test_file_base64'
    #       obj.valid?
    #       expect(obj.valid?).to be false
    #     end
    #   end
    # end
  end
end
