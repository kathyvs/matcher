
require 'name_matcher/error_handler'
require 'pry'

describe 'ErrorHandler' do

  context 'for handle_errors' do

    it 'yields its block once' do
      expect { |probe| NameMatcher::ErrorHandler.handle_errors(&probe) }.to yield_control.once
    end

    it 're-raises SignalException' do
      signal = SignalException.new('INT')
      expect {
        NameMatcher::ErrorHandler.handle_errors do
          raise signal
        end
      }.to raise_error do |actual_error|
        actual_error == signal
      end
    end

    it 're-raises SystemExit' do
      exit_error = SystemExit.new(5, 'Test Exit')
      expect {
        NameMatcher::ErrorHandler.handle_errors do
          raise exit_error
        end
      }.to raise_error(exit_error.message)
    end

    context 'for other errors' do

      let(:test_exception) {
        StandardError.new("Test Message")
      }

      it 'prints error message to stderr' do
        expect {
          begin
            NameMatcher::ErrorHandler.handle_errors do
              raise test_exception
            end
          rescue SystemExit
            # ignore for this test
          end
        }.to output(test_exception.message + "\n").to_stderr
      end

      it 'exits with 1' do
        expect {
          NameMatcher::ErrorHandler.handle_errors do
            raise test_exception
          end
        }.to raise_error(SystemExit) do |error|
          error.status == 1
        end
      end
    end
  end
end
