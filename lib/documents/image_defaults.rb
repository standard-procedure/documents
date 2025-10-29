module Documents
  module ImageDefaults
    def self.for attachment
      attachment.variant :xtiny, resize_to_limit: [32, 32]
      attachment.variant :tiny, resize_to_limit: [64, 64]
      attachment.variant :thumb, resize_to_limit: [128, 128]
      attachment.variant :small, resize_to_limit: [256, 256]
      attachment.variant :medium, resize_to_limit: [512, 512]
      attachment.variant :large, resize_to_limit: [1024, 1024]
      attachment.variant :xlarge, resize_to_limit: [4096, 4096]
    end
  end
end
