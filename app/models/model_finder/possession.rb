module ModelFinder
  class Possession
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def get_possessions
        stat_calculator = ::StatCalculators::TeamCustomState.new(params)

        if params.keys.include?(:number_of_games)
            stat_calculator.get_possessions_by_number
        else
            stat_calculator.get_possessions_by_dates
        end
      end
    end
end
