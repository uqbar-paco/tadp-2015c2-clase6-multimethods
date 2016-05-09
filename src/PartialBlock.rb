class PartialBlock

  attr_reader :types, :block

  def initialize(types,&block)
    @types = types
    @block = block
  end

  def matches(*parameters)
    parameter_types = parameters.map {|param| param.class}
    match_types(*parameter_types)
  end

  def match_types(*received_types)
    return false if received_types.size != types.size
    received_types.zip(types).all? do |received_type,type|
      case type
        when Module
          received_type <= type
        when Array
          type.all? { |method| received_type.instance_methods.include? method }
      end
    end
  end

  def call(*parameters)
    throw ArgumentError if !matches(*parameters)
    block.call(*parameters)
  end

   def parameters_distance(*parameters)
     @types.zip(parameters).map  do |type,parameter|
       case type
         when Module
           parameter.class.ancestors.index(type)
         when Array
           ancestor = parameter.class.ancestors
                          .detect { |ancestor| type.any? {|method|ancestor.instance_methods(false).include? method} }
           parameter.class.ancestors.index(ancestor)
       end
     end.reduce(:+)
   end

end