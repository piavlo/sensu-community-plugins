module Sensu
  module Extension
    class PruneHybirdCheckMetrics< Mutator
      def name
        'prune_hybird_check_metrics'
      end

      def description
        'prunes metrics from hybird check event'
      end

      def run(event, settings, &block)
        if event[:check][:type] == 'hybird'
          begin
            output = Oj.load(event[:check][:output])
            if output[:metrics]
              event[:check][:output] = output[:description]
              block.call(Oj.dump(event), 0)
            else
              block.call('no description was found in the hybird event output', 2)
            end
          rescue => error
            block.call(error.message, 1)
          end
        else
          block.call(Oj.dump(event), 0)
        end
      end
    end
  end
end
