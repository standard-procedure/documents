require "rails_helper"

module Documents
  RSpec.describe OptionsConverter do
    include OptionsConverter

    it "converts an options hash into an array of OptionsValues" do
      options = {first: "First option", second: "Second option", "3": "Third"}

      values = convert_options(options)

      expect(values).to be_kind_of Array
      expect(values.first).to eq({"key" => "first", "value" => "First option", "colour" => "#999999", "score" => 0.0})
      expect(values.second).to eq({"key" => "second", "value" => "Second option", "colour" => "#999999", "score" => 0.0})
      expect(values.third).to eq({"key" => "3", "value" => "Third", "colour" => "#999999", "score" => 3.0})
    end

    it "returns the keys" do
      items = [{"key" => "first", "value" => "First option", "colour" => "#333333", "score" => 0.0}, {"key" => "second", "value" => "Second option", "colour" => "#aaaaaa", "score" => 75.0}]

      keys = keys_from(items)

      expect(keys.size).to eq 2
      expect(keys.first).to eq "first"
      expect(keys.last).to eq "second"
    end

    it "returns the values" do
      items = [{"key" => "first", "value" => "First option", "colour" => "#333333", "score" => 0.0}, {"key" => "second", "value" => "Second option", "colour" => "#aaaaaa", "score" => 75.0}]

      values = values_from(items)

      expect(values.size).to eq 2
      expect(values.first).to eq "First option"
      expect(values.last).to eq "Second option"
    end

    it "finds the key for the given value" do
      items = [{"key" => "first", "value" => "First option", "colour" => "#333333", "score" => 0.0}, {"key" => "second", "value" => "Second option", "colour" => "#aaaaaa", "score" => 75.0}]

      key = key_from(items, value: "First option")
      expect(key).to eq "first"
    end

    it "finds the value for the given key" do
      items = [{"key" => "first", "value" => "First option", "colour" => "#333333", "score" => 0.0}, {"key" => "second", "value" => "Second option", "colour" => "#aaaaaa", "score" => 75.0}]

      value = value_from(items, key: "second")
      expect(value).to eq "Second option"
    end

    it "finds the colour for the given key" do
      items = [{"key" => "first", "value" => "First option", "colour" => "#333333", "score" => 0.0}, {"key" => "second", "value" => "Second option", "colour" => "#aaaaaa", "score" => 75.0}]

      colour = colour_from(items, key: "second")
      expect(colour).to eq "#aaaaaa"
    end

    it "finds the score for the given key" do
      items = [{"key" => "first", "value" => "First option", "colour" => "#333333", "score" => 0.0}, {"key" => "second", "value" => "Second option", "colour" => "#aaaaaa", "score" => 75.0}]

      score = score_from(items, key: "second")
      expect(score).to eq 75.0
    end
  end
end
