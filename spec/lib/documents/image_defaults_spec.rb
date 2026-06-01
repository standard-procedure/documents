require "rails_helper"

module Documents
  RSpec.describe ImageDefaults do
    # Stands in for the Active Storage reflection that Rails yields to the
    # `has_*_attached ... do |attachable| ImageDefaults.for(attachable) end`
    # block. It records each variant declaration so we can inspect the options
    # ImageDefaults passes - in particular `preprocessed:`.
    def collector
      Class.new {
        def variants = @variants ||= {}

        def variant(name, **transformations) = variants[name] = transformations
      }.new
    end

    around do |example|
      was = Documents::ImageDefaults.preprocess
      example.run
      Documents::ImageDefaults.preprocess = was
    end

    it "declares the standard set of resized variants" do
      builder = collector

      Documents::ImageDefaults.for builder

      expect(builder.variants.keys).to eq %i[xtiny tiny thumb small medium large xlarge]
      expect(builder.variants[:tiny][:resize_to_limit]).to eq [64, 64]
      expect(builder.variants[:xlarge][:resize_to_limit]).to eq [4096, 4096]
    end

    it "does not preprocess variants by default" do
      builder = collector

      Documents::ImageDefaults.for builder

      expect(builder.variants.values.map { |options| options[:preprocessed] }).to all(eq(false))
    end

    it "preprocesses every variant when preprocessing is enabled" do
      Documents::ImageDefaults.preprocess = true
      builder = collector

      Documents::ImageDefaults.for builder

      expect(builder.variants.values.map { |options| options[:preprocessed] }).to all(eq(true))
    end
  end
end
