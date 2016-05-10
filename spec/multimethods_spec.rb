require 'rspec'
require_relative '../src/multimethods'
require_relative '../src/refinements'
require_relative '../src/partial_block'

describe 'Multimethods' do

  describe 'Multimethods' do

    class A
      partial_def :concat, [String, String] do |s1, s2|
        s1 + s2
      end

      partial_def :concat, [String, Integer] do |s1, n|
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
        expect { A.new.concat(['hello', ' world', '!']) }.to raise_error(NoMethodError)
      end

    end

    describe 'Asking for Multimethods' do
      it 'deberia retornar la lista de simbolos de multimethods definidos' do
        expect(A.multimethods).to eq [:concat]
      end

      it 'obtener representacion de multimethod' do
        expect(A.multimethod(:concat).selector).to eq(:concat)
      end

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

end