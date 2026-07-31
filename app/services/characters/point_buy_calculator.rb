class Characters::PointBuyCalculator
  COSTS = {
    8 => 0, 9 => 1, 10 => 2, 11 => 3, 12 => 4, 13 => 5, 14 => 7, 15 => 9
  }.freeze
  MAXIMUM_POINTS = 27

  attr_reader :ability_scores

  def initialize(ability_scores)
    @ability_scores = ability_scores.stringify_keys
  end

  def valid?
    scores.size == Character::ABILITIES.size &&
      scores.all? { |score| COSTS.key?(score) } &&
      total_cost <= MAXIMUM_POINTS
  end

  def total_cost
    scores.sum { |score| COSTS.fetch(score, MAXIMUM_POINTS + 1) }
  end

  private

    def scores
      Character::ABILITIES.map { |ability| Integer(ability_scores.fetch(ability.to_s)) }
    rescue ArgumentError, TypeError, KeyError
      []
    end
end
