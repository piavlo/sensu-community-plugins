module Sensu
  module Extension
    class HybirdCheckMetrics < Mutator
      def name
        'hybird_check_metrics'
      end

      def description
        'returns metrics from hybird check event'
      end

      def run(event, settings, &block)
        if event[:check][:type] == 'hybird'
          begin
            output = Oj.load(event[:check][:output])
            if output[:metrics]
              block.call(output[:metrics], 0)
            else
              block.call('no metrics where found in the hybird event output', 2)
            end
          rescue => error
            block.call(error.message, 2)
          end
        else
          block.call(event[:check][:output], 0)
        end
      end
    end
  end
end
