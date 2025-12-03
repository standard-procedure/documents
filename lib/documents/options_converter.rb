module Documents
  module OptionsConverter
    def convert_options options
      options.map { |k, v| {"key" => k.to_s, "value" => v.to_s, "colour" => "#999999", "score" => k.to_s.to_f} }
    end

    def keys_from items
      items.map { |item| item["key"] }
    end

    def values_from items
      items.map { |item| item["value"] }
    end

    def key_from items, value:
      items.find { |item| item["value"] == value.to_s }&.dig("key")
    end

    def item_from items, key:
      items.find { |item| item["key"] == key.to_s }
    end

    def value_from items, key:
      item_from(items, key: key)&.dig("value")
    end

    def colour_from items, key:
      item_from(items, key: key)&.dig("colour")
    end

    def score_from items, key:
      item_from(items, key: key)&.dig("score")
    end
  end
end
