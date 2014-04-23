newrelic-carrierwave
====================

Note: There are no tests because New Relic's test suite is crazy-town. This has been running in production on Househappy.org for over a year with no issues.

## CarrierWave Instrumentation 

This gem provides New Relic instrumentation for the CarrierWave gem. There are two main components which are instrumented, image processing and FOG based file storage/retrieval. If you have bugs or problems with this gem, please open up an issue, here. 

### Storage Methods* (FOG) 

    CarrierWave::Storage::Fog#store!
    CarrierWave::Storage::Fog#retrieve
    CarrierWave::Storage::Fog#authenticated_url
    CarrierWave::Storage::Fog#public_url

    ::CarrierWave::SanitizedFile#copy_to
    ::CarrierWave::SanitizedFile#move_to


*These report under the "external" section

### General Image Processor Methods

    CarrierWave::Uploader::Versions::ClassMethods#version

### VIPS

    CarrierWave::Vips#manipulate!
    CarrierWave::Vips#resize_image
    CarrierWave::Vips#resize_to_limit
    CarrierWave::Vips#resize_to_fill

### RMagick


    CarrierWave::RMagick#manipulate!
    CarrierWave::RMagick#resize_image
    CarrierWave::RMagick#resize_to_limit
    CarrierWave::RMagick#resize_to_fill
    CarrierWave::RMagick#resize_and_pad
    CarrierWave::RMagick#resize_to_geometry_string
    CarrierWave::RMagick#convert

### MiniMagick

    CarrierWave::MiniMagick#manipulate!
    CarrierWave::MiniMagick#resize_image
    CarrierWave::MiniMagick#resize_to_limit
    CarrierWave::MiniMagick#resize_to_fill
    CarrierWave::MiniMagick#resize_and_pad
    CarrierWave::MiniMagick#convert


### Copyright
NewRelic RPM and CarrierWave have their respective licenses, please look at their documentation to find out more. 

The code specific to this gem is Copyright © 2013 Servando Salazar. See [MIT-LICENSE](http://github.com/tehprofessor/newrelic-carrierwave/blob/master/MIT-LICENSE) for details.
