class Module

  def partial_def(sym, types, &block)
    partial_block = PartialBlock.new(types, &block)
    multimethod = get_multimethod(sym)
    multimethod.definitions << partial_block
    self.send(:define_method, sym) do |*args|
      multimethod.call(*args)
    end
  end

  def actual_multimethods
    @actual_multimethods ||= []
  end

  def multimethod(sym)
    self.actual_multimethods.find { |mm| mm.selector.eql?(sym) }
  end

  def multimethods
    self.actual_multimethods.map { |mm| mm.selector }
  end

  private

  def has_multimethod?(multimethod)
    self.actual_multimethods.include?(multimethod)
  end

  def get_multimethod(sym)
    multimethod = self.multimethod(sym) || MultiMethod.new(sym)
    actual_multimethods << multimethod unless self.has_multimethod?(multimethod)
    multimethod
  end

end


class Object

  def respond_to?(sym, include_private = false, signature = nil)
    signature.nil? ? super(sym, include_private) : self.class.actual_multimethods.any? { |mm| mm.matches?(signature) }
  end

=begin
  partial_def :respond_to?, [Symbol] do |sym|
    self.old_respond_to?(sym)
  end

  partial_def :respond_to?, [Symbol, Object] do |sym, bool|
    self.old_respond_to?(sym, bool)
  end

  partial_def :respond_to?, [Symbol, Object, Array] do |sym, bool, types|
    false unless self.class.multimethods.include?(sym)
    multimethod = self.class.multimethod(sym)
    multimethod.matches_signature?(types)
  end
=end

end