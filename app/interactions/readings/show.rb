class Readings::Show < ActiveInteraction::Base
  string :user


  def execute
    get_user_readings.sort_by { |reading| reading[:timestamp] }.reverse[0]
  end

  def get_user_readings
    @client = Redis.new
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