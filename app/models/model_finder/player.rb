module ModelFinder
  class Player
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def find
      scope = ::Player.distinct
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
        .where("LOWER(first_name) LIKE LOWER(?)
          OR LOWER(last_name) LIKE LOWER(?)
          OR LOWER((first_name || ' ' || last_name)) LIKE LOWER(?)",
          "%#{params[param]}%",
          "%#{params[param]}%",
          "%#{params[param]}%")
    end

    def team(scope, param)
      scope
      .joins(:teams)
        .where("LOWER(teams.city) LIKE LOWER(?)
          OR LOWER(teams.mascot) LIKE LOWER(?)
          OR LOWER((teams.city || ' ' || teams.mascot)) LIKE LOWER(?)",
          "%#{params[param]}%",
          "%#{params[param]}%",
          "%#{params[param]}%")
    end

    def season(scope, param)
      scope
        .where("LOWER(players.season) LIKE LOWER(?)",
          "%#{params[param]}%")
        .where("team_id != 0")
    end

    def searchable_params
      %w(name team season)
    end
  end
end
