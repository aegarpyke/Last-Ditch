class Attributes < Component

  attr_accessor :attributes

  def initialize
    super()

    @attributes = Hash.new

    attribute_data = YAML.load_file('cfg/attributes.yml')
    attribute_list = attribute_data['attribute_list']

    for attribute in attribute_list
      @attributes[attribute] = 0.01
    end
  end

end
