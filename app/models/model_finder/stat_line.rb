module ModelFinder
  class StatLine
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def find
      scope = ::StatLine.distinct
      params.keys.reduce(scope) do |scope, param|
        if searchable_params.include?(param)
          self.send(param, scope, param)
        else
          scope
        end
      end
    end

    def name(scope, param)
      scope
        .joins(:player)
        .where("LOWER(players.first_name) LIKE LOWER(?)
          OR LOWER(players.last_name) LIKE LOWER(?)
          OR LOWER((players.first_name || ' ' || players.last_name)) LIKE LOWER(?)",
          "%#{params[param]}%",
          "%#{params[param]}%",
          "%#{params[param]}%")
    end

    def team(scope, param)
      scope
      .joins(:team)
        .where("LOWER(teams.city) LIKE LOWER(?)
          OR LOWER(teams.mascot) LIKE LOWER(?)
          OR LOWER((teams.city || ' ' || teams.mascot)) LIKE LOWER(?)",
          "%#{params[param]}%",
          "%#{params[param]}%",
          "%#{params[param]}%")
    end

    def searchable_params
      %w(name team)
    end
  end
end
