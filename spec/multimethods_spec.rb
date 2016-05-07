require 'rspec'
require_relative '../src/multimethods'

describe 'Multimethods' do
  helloBlock = PartialBlock.new([String]) do |who|
    "Hello #{who}"
  end

  it 'primer punto' do
    expect(helloBlock.matches "a").to eq(true)
    expect(helloBlock.matches 1).to eq(false)
    expect(helloBlock.matches "a", "b").to eq(false)
  end

  it 'should execute the block if the matching succeeded' do
    expect(helloBlock.call('world')).to eq 'Hello world'
  end

  it 'should throw ArgumentError if matching did not succeed' do
    expect{helloBlock.call(10)}.to raise_error ArgumentError
  end

  it 'multimethods' do
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

    expect(A.new.concat('hello', ' world')).to eq('hello world')
    expect(A.new.concat('hello', 3)).to eq('hellohellohello')
    expect{A.new.concat(['hello', ' world','!'])}.to raise_error(NoMethodError)

    expect(A.multimethods).to eq [:concat]


    expect(A.new.concat(Object.new, 3)).to eq('Objetos Concatenados')


  end

  it 'respond_to' do
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


    expect(A.new.respond_to? :concat).to eq(true)
    expect(A.new.respond_to? :is_a?).to eq(true)
    expect(A.new.respond_to? :concat, false, [String, String]).to eq(true)
    expect(A.new.respond_to? :concat, false, [String, A]).to eq(true)
    expect(A.new.respond_to? :concat, false, [String]).to eq(false)
    expect(A.new.respond_to? :concat, false, [String, String, String]).to eq(false)


  end

  it 'Implemento duck typing' do

    class B
      partial_def :concat, [String, [:m, :n], Integer] do |o1, o2, o3|
        'Objetos Concatenados'
      end
    end
  end


end