require "rumale"
require "rumale/torch"
require "chunky_png"
require_relative "./neural_network.rb"

module HDR
  class Service
    INPUT_LAYER = 784
    INNER_LAYERS = [1024, 256]
    OUTPUT_LAYER = 10
    IMAGE_SIZE = 28

    class << self
      def create_libsvm_and_image_from_base64(data)
        rand = (0...6).map { (65 + rand(26)).chr }.join.downcase

        digit_image_path = "#{rand}_image.png"

        canvas = ChunkyPNG::Canvas.from_data_url(data)
        canvas.to_image.save("data/#{digit_image_path}")
        canvas.resample_bilinear!(IMAGE_SIZE, IMAGE_SIZE)
        canvas.to_image.save("data/smaller_#{digit_image_path}")

        values = canvas.pixels.map { |a|
          255 - (ChunkyPNG::Color.r(a))
        }.map.with_index {
          |value, index|
          "#{index + 1}:#{value}"
        }.join(" ")

        libsvm_set_path = "data/#{rand}.libsvm"

        File.open(libsvm_set_path, "wb") do |f|
          f.write("0 #{values}")
        end

        { libsvm_set_path: libsvm_set_path, digit_image_path: digit_image_path }
      end

      def predict_from_libsvm(libsvm_file_path)
        net = HDR::NeuralNetwork.new(INPUT_LAYER, OUTPUT_LAYER, INNER_LAYERS)
        net.load_state_dict(Torch.load("models/model.pth"))

        # Loading classifier
        classifier = Marshal.load(File.binread("models/model.dat"))
        classifier.model = net

        # Loading test dataset
        x_test, y_test = Rumale::Dataset.load_libsvm_file(libsvm_file_path)

        # Predict labels of test data
        classifier.predict(x_test)
      end
    end
  end
end