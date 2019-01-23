require_relative 'player'

class AiPlayer < Player

  attr_reader :strategy

  def set_strategy strategy_choice
    if strategy_choice_valid? strategy_choice
      @strategy = available_strategies[strategy_choice - 1]
    end
  end

  def valid?
    available_strategies.include? strategy
  end

  def strategy_choice_valid? strategy_choice
    strategy_choice > 0 && strategy_choice <= available_strategies.length
  end

  def available_strategies
    [:random, :minimax]
  end
end
