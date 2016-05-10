class MultiMethod

  attr_accessor :selector, :definitions

  def initialize(sym)
    self.selector = sym
    self.definitions = []
  end

  def call(*args)
    definition = self.definitions
                     .select { |definition| definition.matches(*args) }
                     .min_by { |definition| definition.distance_to(*args) }
    definition ? definition.call(*args) : raise(NoMethodError)
  end

  def matches?(types)
    self.definitions.any? do |definition|
      definition.matches_signature?(types)
    end
  end

end

