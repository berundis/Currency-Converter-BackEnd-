require 'net/http'
require 'open-uri'

class Api::V1::ExchangesController < ApplicationController

  def index 
    render json: Exchange.all, status: 200
  end 

  def create
    name = exchange_params[:name]
    if Exchange.fetch?(name)
      url = "https://free.currencyconverterapi.com/api/v6/convert?q=#{name}&compact=y"
      uri = URI.parse(url)
      response = Net::HTTP.get_response(uri)
      value =  JSON(response.body)[exchange_params[:name]]['val']
      Exchange.create(name: name, value: value)
    else  
      value = Exchange.find_by(name: name).value
    end 
    answer = value.to_f * exchange_params[:value].to_f

    render json: answer, status: 200
  end

  private

  def exchange_params
    params.require(:exchange).permit(:value, :name)
  end

end

