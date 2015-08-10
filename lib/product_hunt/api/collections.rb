module ProductHunt
  module API
    module Collections

      PATH = "/collections"

      def collections(options = {})
        process(PATH, options) do |response|
          response["collections"].map{ |collection| Collection.new(collection, self) }
        end
      end

    end
  end
end
