require_relative "lib/documents/version"
Gem::Specification.new do |spec|
  spec.name = "standard_procedure_documents"
  spec.version = Documents::VERSION
  spec.authors = ["Rahoul Baruah"]
  spec.email = ["rahoulb@echodek.co"]
  spec.homepage = "https://theartandscienceofruby,com/"
  spec.summary = "Standard Procedure: Documents"
  spec.description = "Documents"
  spec.license = "LGPL"

  spec.metadata["allowed_push_host"] = "https://rubygems.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/standard_procedure"
  spec.metadata["changelog_uri"] = "https://github.com/standard_procedure"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.3"
  spec.add_dependency "dry-validation"
  spec.add_dependency "standard_procedure_has_attributes"
  spec.add_dependency "positioning"
end
