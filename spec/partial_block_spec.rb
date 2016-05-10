require 'rspec'
require_relative '../src/partial_block'

describe 'PartialBlock Spec' do

  hello_block = PartialBlock.new([String]) do |who|
    "Hello #{who}"
  end

  duck_block = PartialBlock.new([String, [:size]]) do |str, arr|
    str + arr.size
  end

  describe PartialBlock do

    describe 'Matching' do

      it 'deberia matchear con parametros que coinciden con alguna firma' do
        expect(hello_block.matches "a").to eq(true)
      end

      it 'no deberia matchear con parametros que no coinciden con ninguna firma' do
        expect(hello_block.matches 1).to eq(false)
      end

      it 'no deberia matchear con parametros que no coinciden con ninguna firma' do
        expect(hello_block.matches "a", "b").to eq(false)
      end

      it 'debería matchear según duck typing si define dichos métodos' do
        expect(duck_block.matches "str", [1, 2, 3]).to eq(true)
      end

    end

    describe 'Calling' do

      it 'deberia ejecutar su bloque si los parametros matchean' do
        expect(hello_block.call('world')).to eq 'Hello world'
      end

      it 'deberia tirar error si los parametros no matchean' do
        expect { hello_block.call(10) }.to raise_error ArgumentError
      end

    end

  end

end