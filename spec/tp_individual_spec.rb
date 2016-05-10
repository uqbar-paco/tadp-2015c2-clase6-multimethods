require 'rspec'
require_relative '../src/multimethods'
require_relative '../src/refinements'
require_relative '../src/partial_block'

describe 'TP Duck Typing' do

  describe 'Duck Typing' do
    class B

      partial_def :concat, [String, [:m, :n], Integer] do |o1, o2, o3|
        'Objetos Concatenados'
      end

    end

    class Psyduck

      def m
        'psyduck!'
      end

      def n
        'Psyduck is confused... It hurt itself in its confusion!'
      end

    end

    it 'deberia andar con duck typing' do
      expect(B.new.concat('sarlomps', Psyduck.new, 3)).to eq 'Objetos Concatenados'
    end

  end

end