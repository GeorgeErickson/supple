module Supple
  module Util
    module IncludedTracker
      def descendants
        Rails.application.eager_load! if defined?(Rails)
        ActiveSupport::DescendantsTracker.descendants(self)
      end

      def append_features(base)
        previous = ActiveSupport::DescendantsTracker.descendants(self)
        binding.pry
        ActiveSupport::DescendantsTracker.store_inherited(self, base) unless previous.include?(base)
      end
    end
  end
end
