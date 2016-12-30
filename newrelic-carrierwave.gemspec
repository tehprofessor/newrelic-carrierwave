# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'newrelic_carrierwave/version'

Gem::Specification.new do |s|
  s.name = "newrelic-carrierwave"
  s.version = NewRelicCarrierWave::VERSION

  s.authors = ["Servando Salazar"]
  s.date = "2013-01-24"
  s.description = "Carrierwave instrumentation for Newrelic."
  s.email = ["servando@gmail.com"]
  s.files = [
    "lib/newrelic-carrierwave.rb",
    "lib/newrelic_carrierwave/instrumentation.rb",
    "lib/newrelic_carrierwave/version.rb"
  ]
  s.homepage = "http://github.com/tehprofessor/carrierwave-newrelic"
  s.require_paths = ["lib"]
  s.summary = "Carrierwave instrumentation for Newrelic."
  s.test_files = []

  s.add_dependency "carrierwave", ">= 0.8", "< 1.1"
  s.add_dependency "newrelic_rpm", "~> 3.0"

  s.add_development_dependency "rdoc", "~> 3.10"
end
