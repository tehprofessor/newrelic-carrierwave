require 'new_relic/agent/method_tracer'
require 'new_relic/agent/instrumentation/controller_instrumentation'

module NewRelicCarrierWave
  module ImageProcessorTracers
    def self.included(base)
      base.class_eval do
        base.send(:include, NewRelic::Agent::Instrumentation::ControllerInstrumentation)
        base.send(:add_method_tracer, :resize_to_limit) if base.send(:respond_to?, :resize_to_limit)
        base.send(:add_method_tracer, :resize_to_fill) if base.send(:respond_to?, :resize_to_fill)
        base.send(:add_method_tracer, :resize_to_fit) if base.send(:respond_to?, :resize_to_fit)
        base.send(:add_method_tracer, :resize_and_pad) if base.send(:respond_to?, :resize_and_pad)
        base.send(:add_method_tracer, :manipulate!) if base.send(:respond_to?, :manipulate!)
      end
    end
  end
end

DependencyDetection.defer do
  @name = :carrierwave

  depends_on do
    NewRelic::Agent.logger.debug 'Installing CarrierWave Instrumentation'
    defined?(::CarrierWave) &&
    !NewRelic::Control.instance['disable_carrierwave'] &&
    ENV['NEWRELIC_ENABLE'].to_s !~ /false|off|no/i
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing CarrierWave Instrumentation'
  end

  executes do
    ::CarrierWave::Storage::Fog.class_eval do
      def call_store_with_newrelic_trace(file)

        metrics = ["External/CarrierWave/Fog"]

        if NewRelic::Agent::Instrumentation::MetricFrame.recording_web_transaction?
          total_metric = 'External/allWeb'
        else
          total_metric = 'External/allOther'
        end
        metrics << total_metric
        self.class.trace_execution_scoped(metrics) do
          call_storage_without_newrelic_trace(file)
        end
      end

      alias :call_store_without_newrelic_trace :store!
      alias :store! :call_store_with_newrelic_trace
    end

    ::CarrierWave::Uploader::Versions::ClassMethods.class_eval do

      def version_with_newrelic_trace(name, options = {}, &block)
        metrics = ["Custom/Carrierwave/Version/#{name}"]
        self.class.trace_execution_scoped(metrics) do
          version_without_newrelic_trace(name, options, &block)
        end
      end

      alias :version_without_newrelic_trace :version
      alias :version :version_with_newrelic_trace

    end
  end
end

DependencyDetection.defer do
  @name = :carrierwave_image_processing

  depends_on do
    defined?(::CarrierWave::Vips) &&
    !NewRelic::Control.instance['disable_carrierwave_image_processing'] &&
    ENV['NEWRELIC_ENABLE'].to_s !~ /false|off|no/i
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing CarrierWave Image Processing Instrumentation'
  end

  executes do
    if defined?(::CarrierWave::Vips)
      ::CarrierWave::Vips.class_eval do
        include NewRelicCarrierWave::ImageProcessorTracers
        add_transaction_tracer(:resize_image) if respond_to?(:resize_image)
      end
    end
  end

  executes do
    if defined?(::CarrierWave::MiniMagick)
      ::CarrierWave::MiniMagick.class_eval do
        include NewRelicCarrierWave::ImageProcessorTracers
      end
    end
  end

  executes do
    if defined?(::CarrierWave::RMagick)
      ::CarrierWave::MiniMagick.class_eval do
        include NewRelicCarrierWave::ImageProcessorTracers
      end
    end
  end
end

