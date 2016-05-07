class PartialBlock

  attr_reader :types, :block

  def initialize(types,&block)
    @types = types
    @block = block
  end

  def matches(*parameters)
    return false if parameters.size != types.size
    parameters.zip(types).all? do |parameter,type|
      parameter.is_a? type
    end
  end

  def match_types(*received_types)
    puts received_types.to_s,types.to_s
    return false if received_types.size != types.size
    received_types.zip(types).all? do |received_type,type|
      received_type <= type
    end
  end

  def call(*parameters)
    throw ArgumentError if !matches(*parameters)
    block.call(*parameters)
  end

   def parameters_distance(*parameters)
     @types.zip(parameters).map  { |type,parameter| parameter.class.ancestors.index(type) }.reduce(:+)
   end

end