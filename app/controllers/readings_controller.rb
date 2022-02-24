class ReadingsController < ApplicationController
  def create
    creation = Readings::Create.run(user: reading_params[:id],readings: reading_params[:readings].map { |r|  r.to_h })
    if creation.valid?
      head :ok
    else
      head :no_content
    end
  end

  def last_reading
    render json: Readings::Show.run(user: params[:id]).result, status: :ok
  end

  def accumulative
    render json: Readings::Accumulative.run(user: params[:id]).result, status: :ok
  end

  def reading_params
    params.fetch(:reading).permit(:id,readings:[:count, :timestamp])
  end
end
