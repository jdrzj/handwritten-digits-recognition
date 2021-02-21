require "sinatra"
require "sinatra/base"
require "uri"
require "./service.rb"

class App < Sinatra::Base
  get "/" do
    File.read("./public/draw.html")
  end

  post "/predict" do
    base64_data = URI.unescape(params[:data])
    paths = Service.create_libsvm_and_image_from_base64(base64_data)
    result = Service.predict_from_libsvm(paths[:libsvm_set_path])
    "IT IS: #{result[0]}"
  end

  run! if app_file == $0
end
