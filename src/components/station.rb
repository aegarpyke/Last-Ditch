class Station < Component

  attr_accessor :name, :type

  def initialize(type)

    super()

    station_data = YAML.load_file('cfg/stations.yml')

    @type = type
    @name = station_data[type]['name']

  end

end