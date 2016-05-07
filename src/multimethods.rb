require_relative '../src/PartialBlock'

class Module


  def partial_def(sym, types, &block)
    partial_block = PartialBlock.new types, &block
    define_multimethod sym, partial_block
    self.send(:define_method, sym) do |*args|
      multimethod = singleton_class.multimethod(sym)
      multimethod.nil? ? raise(NoMethodError) : multimethod.call(self, *args)
    end
  end

  def define_multimethod(sym, partial_block)
    multimethod = has_multimethod?(sym) ? multimethod(sym) : create_multimethod(sym)
    multimethod.add_definition partial_block
  end

  def create_multimethod(sym)
    mm =MultiMethod.new(sym)
    @multimethods ||= []
    @multimethods << mm
    mm
  end

  def multimethods
    multimethod_objects.map { |mm| mm.sym }
  end

  def multimethod_objects(include_ancestors = false)
    @multimethods ||= []
    include_ancestors ? ancestors.flat_map {|a| a.multimethod_objects} : @multimethods

  end

  def has_multimethod?(sym)
    multimethod_objects(true).any? do |mm|
      mm.sym == sym
    end
  end

  def multimethod(sym)
    multimethod_objects(true).detect do |mm|
      mm.sym == sym
    end
  end

end

class Object
  alias_method :old_respond_to?, :respond_to?
  
  def respond_to? (sym, is_private = false, types = nil)
    types.nil? ? old_respond_to?(sym, is_private) : singleton_class.multimethod_objects(true).any? { |mm| mm.comply?(sym, types) }
  end
end


class MultiMethod

  attr_accessor :sym

  def initialize(sym)
    @sym = sym
    @blocks = []
  end

  def matches(*args)
    @blocks.any? do |block|
      block.matches(*args)
    end
  end

  def call(instance, *args)
    block = best_block(*args)
    block.nil? ? raise(NoMethodError) : instance.instance_exec(*args, &block.block)
  end

  def best_block(*parameters)
    @blocks.select { |partial_block| partial_block.matches(*parameters) }
        .min_by { |partial_block| partial_block.parameters_distance(*parameters) }
  end

  def add_definition(partial_block)
    @blocks << partial_block
  end

  def comply?(sym, types)
    @sym == sym && @blocks.any? { |partial_block| partial_block.match_types(*types) }
  end

end