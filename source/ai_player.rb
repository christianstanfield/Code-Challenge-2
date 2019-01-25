require_relative 'player'

class AiPlayer < Player

  attr_reader :strategy

  def select_column board, players
    if strategy_random?
      board.available_columns.sample
    elsif strategy_minimax?
      weigh_outcomes board, players
    end
  end

  def set_strategy strategy_choice
    if strategy_choice_valid? strategy_choice
      @strategy = available_strategies[strategy_choice - 1]
    end
  end

  def valid?
    available_strategies.include? strategy
  end

  def available_strategies
    [:random, :minimax]
  end

  private

  def weigh_outcomes board, players
    outcomes     = board.available_columns.map { |column| [column, 0] }.to_h
    filthy_human = players.find { |player| player.game_piece != game_piece }

    board.available_columns.each do |column|
      test_board = board.duplicate
      test_board.update_state column, game_piece

      if test_board.winning_player players
        outcomes[column] = 1
      else
        test_board.available_columns.each do |next_column|
          next_level_test_board = test_board.duplicate
          next_level_test_board.update_state next_column, filthy_human.game_piece

          if next_level_test_board.winning_player players
            outcomes[column] = -1
          end
        end
      end
    end

    pick_best_outcome outcomes
  end

  def pick_best_outcome outcomes
    best_outcome = outcomes.values.max
    outcomes.key best_outcome
  end

  def strategy_choice_valid? strategy_choice
    strategy_choice > 0 && strategy_choice <= available_strategies.length
  end

  def strategy_random?
    strategy == :random
  end

  def strategy_minimax?
    strategy == :minimax
  end
end
