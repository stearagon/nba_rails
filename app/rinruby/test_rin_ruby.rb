class TestRinRuby
  def self.test_rin_ruby
    R.teams = Team.all.map { |team| team.mascot }
    R.pull "sort(teams)"
  end
end
