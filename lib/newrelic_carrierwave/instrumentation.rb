require 'new_relic/agent/method_tracer'
require 'new_relic/agent/instrumentation/controller_instrumentation'

DependencyDetection.defer do
  @name = :carrierwave

  depends_on do
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
  end
end

DependencyDetection.defer do
  @name = :carrierwave_vips

  depends_on do
    defined?(::CarrierWave::Vips) &&
    !NewRelic::Control.instance['disable_carrierwave_vips'] &&
    ENV['NEWRELIC_ENABLE'].to_s !~ /false|off|no/i
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing CarrierWave::Vips Instrumentation'
  end

  executes do
    if defined?(::CarrierWave::Vips)
      ::CarrierWave::Vips.class_eval do
        include NewRelic::Agent::Instrumentation::ControllerInstrumentation
        add_transaction_tracer(:resize_to_limit) if respond_to?(:resize_to_limit)
        add_transaction_tracer(:resize_to_fill) if respond_to?(:resize_to_fill)
        add_transaction_tracer(:resize_to_fit) if respond_to?(:resize_to_fit)
        add_transaction_tracer(:resize_and_pad) if respond_to?(:resize_and_pad)
        add_transaction_tracer(:resize_geometry_string) if respond_to?(:resize_geometry_string)
        add_transaction_tracer(:manipulate!) if respond_to?(:manipulate!)
      end
    end
  end
end

