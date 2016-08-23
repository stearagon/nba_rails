module Helpers
  class SeasonHelper
    START_MONTH = 10

    def self.start_year(date)
      year = date.year
      start_year = date.mon < START_MONTH ? (year - 1) : year

      start_year.to_s
    end

    def self.season_finder(date)
      year = date.year
      start_year = date.mon < START_MONTH ? (year - 1) : year
      end_year = (start_year + 1) % 1000

      "#{start_year.to_s}-#{end_year.to_s}"
    end
  end
end
