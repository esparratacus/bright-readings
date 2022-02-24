class Readings::Create < ActiveInteraction::Base
  string :user
  array :readings do
    hash do
      date_time :timestamp
      integer :count
    end
  end

  attr_reader :client
  def execute
    @client = Redis.new
    user_readings = get_user_readings
    readings = (@readings + user_readings).uniq
    client.set(user, readings.to_json)
  end

  def get_user_readings
    user_readings = @client.get(user)
    if user_readings
      JSON.parse(user_readings).map do |read|
        read.symbolize_keys!
        {
          count: read[:count],
          timestamp: read[:timestamp].to_datetime
        }
      end
    else
      []
    end
    rescue JSON::ParserError
      []
  end
end