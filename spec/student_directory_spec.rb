require './lib/student_directory.rb'
require 'pry'
require 'colorize'

describe 'Student Directory' do
  describe '#input_name_and_sin' do
    before do
      @students = []
      allow(self).to receive(:name_input).and_return('John')
      allow(self).to receive(:sin_input).and_return('Murder')
    end

    subject { input_name_and_sin }

    it 'adds an entry to students array' do
      expect(@students.length).to eq(0)
      subject
      expect(@students.length).to eq(1)
    end
  end

  describe '#write_to_file' do
    context '@students have data' do
      let!(:test_data) { ["Name,Sin\n", "John,Murder\n"] }
      before do
        @students = [{ name: 'John', sin: 'Murder' }]
      end

      after do
        File.delete('test.csv') if File.exists?('test.csv')
      end

      subject { write_to_file('test.csv') }

      it 'creates file with data in file' do
        expect(File.exists?('test.csv')).to eq(false)
        subject
        expect(File.exists?('test.csv')).to eq(true)
        expect(File.open('test.csv', 'r').readlines).to eq(test_data)
      end
    end

    context '@students have no data' do
      before do
        @students = []
      end

      subject { write_to_file('test.csv') }

      it 'returns error msg and doesnt create file' do
        expect(File.exists?('test.csv')).to eq(false)
        subject
        expect(File.exists?('test.csv')).to eq(false)
      end
    end
  end

  describe '#load_from_file' do
    context 'file exists' do
      before do
        @students = []
        File.open('test.csv', 'w'){ |file| file.puts 'John,Murder' }
      end

      after do
        File.delete('test.csv') if File.exists?('test.csv')
      end

      subject { load_from_file('test.csv') }

      it 'loads data in to students array' do
        expect(@students.any?).to eq(false)
        subject
        expect(@students.any?).to eq(true)
        expect(@students).to eq([{ name: 'John', sin: 'Murder' }])
      end
    end

    context 'file does not exist' do
      before do
        @students = []
      end

      subject { load_from_file('test.csv') }

      it 'does not load data into students array' do
        expect(@students.any?).to eq(false)
        subject
        expect(@students.any?).to eq(false)
      end
    end
  end

  describe '#clear_student_list' do
    before { @students = [{ name: 'John', sin: 'Murder' }] }

    subject { clear_student_list }

    it 'clears the students array' do
      expect(@students.any?).to eq(true)
      subject
      expect(@students.any?).to eq(false)
    end
  end
end
