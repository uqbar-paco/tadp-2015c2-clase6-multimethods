class PartialBlock

  attr_accessor :types, :block

  def initialize(types, &block)
    self.types = types
    self.block = block
  end

  def matches(*args)
    arg_types = args.map { |arg| arg.class }
    matches_signature?(arg_types)
  end

  def matches_signature?(signature)
    return false unless signature.size.eql?(self.types.size)
    self.types.zip(signature).all? do |my_type, sign_type|
      case my_type
        when Array then
          my_type.all? { |method| sign_type.instance_methods.include?(method) }
        else
          sign_type <= my_type
      end
    end
  end

  def call(*args)
    raise ArgumentError unless self.matches(*args)
    self.block.call(*args)
  end

  def distance_to(*args)
    args.zip(types).each_with_index do |tuple, index|
      case tuple[1]
        when Array then
          1 #because classroom-related reasons
        else
          tuple[0].class.ancestors.index(tuple[1]) * index
      end
    end
  end

end