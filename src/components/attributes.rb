class Attributes < Component

  attr_accessor :attributes, :modifiers

  def initialize
    super()

    @attributes = Hash.new
    @modifiers = Hash.new

    attribute_data = YAML.load_file('cfg/attributes.yml')
    attribute_list = attribute_data['attribute_list']

    for attribute in attribute_list
      @attributes[attribute] = 0.1
      @modifiers[attribute] = 0
    end
  end
end
