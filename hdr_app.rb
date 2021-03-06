require 'sinatra'
require 'sinatra/base'
require 'uri'
require './lib/hdr/service'

class HDRApp < Sinatra::Base
  get '/' do
    File.read('./public/draw.html')
  end

  post '/predict' do
    base64_data = URI.unescape(params[:data])
    paths = HDR::Service.create_libsvm_and_image_from_base64(base64_data)
    result = HDR::Service.predict_from_libsvm(paths[:libsvm_set_path])
    "It is #{result}"
  end

  run! if app_file == $0
end
