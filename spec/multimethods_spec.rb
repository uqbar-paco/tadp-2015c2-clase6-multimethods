require 'rspec'
require_relative '../src/multimethods'

describe 'Multimethods' do
  helloBlock = PartialBlock.new([String]) do |who|
    "Hello #{who}"
  end

  describe PartialBlock do

    describe 'Matching' do

      it 'deberia matchear con parametros que coinciden con alguna firma' do
        expect(helloBlock.matches "a").to eq(true)
      end
      it 'no deberia matchear con parametros que no coinciden con ninguna firma' do
        expect(helloBlock.matches 1).to eq(false)
      end
      it 'no deberia matchear con parametros que no coinciden con ninguna firma' do
        expect(helloBlock.matches "a", "b").to eq(false)
      end

    end

    describe 'Calling' do

      it 'deberia ejecutar su bloque si los parametros matchean' do
        expect(helloBlock.call('world')).to eq 'Hello world'
      end

      it 'deberia tirar error si los parametros no matchean' do
        expect{helloBlock.call(10)}.to raise_error ArgumentError
      end


    end

  end

  describe 'Multimethods' do

    class A
      partial_def :concat, [String, String] do |s1, s2|
        s1 + s2
      end

      partial_def :concat, [String, Integer]  do |s1, n|
        s1 * n
      end

      partial_def :concat, [Object, Object] do |o1, o2|
        'Objetos Concatenados'
      end
    end

    describe 'Calling' do
      it 'deberia encontrar la firma correcta y ejecutar el bloque correspondiente' do
        expect(A.new.concat('hello', ' world')).to eq('hello world')
      end

      it 'deberia encontrar la firma correcta y ejecutar el bloque correspondiente' do
        expect(A.new.concat('hello', 3)).to eq('hellohellohello')
      end

      it 'deberia encontrar la firma correcta y ejecutar el bloque correspondiente' do
        expect(A.new.concat(Object.new, 3)).to eq('Objetos Concatenados')
      end

      it 'deberia tirar error cuando no encuentra ninguna firma posible' do
        expect{A.new.concat(['hello', ' world','!'])}.to raise_error(NoMethodError)
      end
    end

    describe 'Asking for Multimethods' do
      it 'deberia retornar la lista de simbolos de multimethods definidos' do
        expect(A.multimethods).to eq [:concat]
      end
    end

    describe 'Respond to' do

      it 'deberia ser verdadero para multimethods' do
        expect(A.new.respond_to? :concat).to eq(true)
      end

      it 'deberia ser verdadero para metodos comunes' do
        expect(A.new.respond_to? :is_a?).to eq(true)
      end

      it 'deberia ser verdadero para multimethods si los tipos coinciden' do
        expect(A.new.respond_to? :concat, false, [String, String]).to eq(true)
      end

      it 'deberia ser verdadero para multimethods si los tipos coinciden' do
        expect(A.new.respond_to? :concat, false, [String, A]).to eq(true)
      end

      it 'deberia ser falso para metodos comunes si le mando tipos' do
        expect(A.new.respond_to? :to_s, false, [String]).to eq(false)
      end

      it 'deberia ser falso para multimethods si los tipos no coinciden' do
        expect(A.new.respond_to? :concat, false, [String]).to eq(false)
      end

      it 'deberia ser falso para multimethods si los tipos no coinciden' do
        expect(A.new.respond_to? :concat, false, [String, String, String]).to eq(false)
      end

    end

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
        expect(B.new.concat('sarlomps',Psyduck.new,3)).to eq 'Objetos Concatenados'
      end

    end

  end



end