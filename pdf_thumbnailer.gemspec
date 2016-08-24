# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pdf_thumbnailer/version'

Gem::Specification.new do |spec|
  spec.name          = 'pdf_thumbnailer'
  spec.version       = PdfThumbnailer::VERSION
  spec.authors       = ['Sean Huber']
  spec.email         = ['seanhuber@seanhuber.com']
  spec.summary       = 'Takes a folder structure of PDF files and generates thumbnail images for all pages of all pdfs.'
  spec.homepage      = 'https://github.com/seanhuber/pdf_thumbnailer'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
