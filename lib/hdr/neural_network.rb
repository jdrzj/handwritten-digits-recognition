require 'rumale'
require 'rumale/torch'

# Class represents neural network
module HDR
  class NeuralNetwork < Torch::NN::Module
    def initialize(input_size, output_size, inner_layers)
      super()
      layers = [input_size, *inner_layers, output_size]

      @dropout = Torch::NN::Dropout.new(p: 0.5)
      @layers_count = layers.count - 1

      @layers_count.times.each do |index|
        instance_variable_set("@fc#{index}".to_sym, Torch::NN::Linear.new(layers[index], layers[index + 1]))
      end
    end

    def forward(x)
      @layers_count.times.each do |index|
        fc = instance_variable_get("@fc#{index}")
        x = fc.call(x)
        unless @layers_count - 1 == index
          x = Torch::NN::F.relu(x)
          x = @dropout.call(x)
        end
      end
      Torch::NN::F.softmax(x)
    end
  end
end
