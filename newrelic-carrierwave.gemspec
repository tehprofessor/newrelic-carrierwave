# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'newrelic_carrierwave/version'

Gem::Specification.new do |s|
  s.name = "newrelic-carrierwave"
  s.version = NewRelicCarrierWave::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Servando Salazar"]
  s.date = "2013-01-23"
  s.description = "Carrierwave instrumentation for Newrelic."
  s.email = ["servando@gmail.com"]
  s.files = ["lib/newrelic-carrierwave.rb", "lib/newrelic_carrierwave/instrumentation.rb", "lib/newrelic_carrierwave/version.rb"]
  s.homepage = "http://github.com/tehprofessor/carrierwave-newrelic"
  s.require_paths = ["lib"]
  s.summary = "Carrierwave instrumentation for Newrelic."
  s.test_files = []

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<carrierwave>, ["~> 0.8"])
      s.add_runtime_dependency(%q<newrelic_rpm>, ["~> 3.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.10"])
    else
      s.add_dependency(%q<carrierwave>, ["~> 0.8"])
      s.add_dependency(%q<newrelic_rpm>, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<carrierwave>, ["~> 0.8"])
    s.add_dependency(%q<newrelic_rpm>, ["~> 3.0"])
  end
end
