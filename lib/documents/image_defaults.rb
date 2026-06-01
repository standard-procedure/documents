module Documents
  module ImageDefaults
    # When true, variants are generated in the background via
    # ActiveStorage::TransformJob as soon as a blob is attached, instead of
    # lazily (and synchronously) on first request. Off by default so consuming
    # apps are unaffected unless they opt in - an app should only enable this
    # if it runs a durable Active Job queue. Set before the models that use
    # `ImageDefaults.for` are loaded (e.g. in an initializer), as the variant
    # declarations are evaluated when the attachment is declared.
    class << self
      attr_accessor :preprocess
    end
    self.preprocess = false

    def self.for attachment
      attachment.variant :xtiny, resize_to_limit: [32, 32], preprocessed: preprocess
      attachment.variant :tiny, resize_to_limit: [64, 64], preprocessed: preprocess
      attachment.variant :thumb, resize_to_limit: [128, 128], preprocessed: preprocess
      attachment.variant :small, resize_to_limit: [256, 256], preprocessed: preprocess
      attachment.variant :medium, resize_to_limit: [512, 512], preprocessed: preprocess
      attachment.variant :large, resize_to_limit: [1024, 1024], preprocessed: preprocess
      attachment.variant :xlarge, resize_to_limit: [4096, 4096], preprocessed: preprocess
    end
  end
end
