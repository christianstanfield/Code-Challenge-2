require_relative 'player'

class AiPlayer < Player

  attr_reader :strategy

  def select_column board, game_pieces
    if strategy_random?
      board.available_columns.sample
    elsif strategy_minimax?
      weigh_outcomes board, game_pieces
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

  def weigh_outcomes board, game_pieces
    outcomes     = board.available_columns.map { |column| [column, 0] }.to_h
    filthy_human = game_pieces.find { |piece| piece != game_piece }

    board.available_columns.each do |column|
      test_board = board.duplicate
      test_board.update_state column, game_piece

      if test_board.winning_player game_pieces
        outcomes[column] = 2
      else
        test_board.available_columns.each do |next_column|
          next_level_test_board = test_board.duplicate
          next_level_test_board.update_state next_column, filthy_human

          if next_level_test_board.winning_player game_pieces
            outcomes[column] = -1
          end
        end

        if outcomes[column] == 0
          test_board.available_columns.each do |next_column|
            next_level_test_board = test_board.duplicate
            next_level_test_board.update_state next_column, game_piece

            if next_level_test_board.winning_player game_pieces
              outcomes[column] = 1
            end
          end
        end
      end
    end

    find_best_outcome outcomes
  end

  def find_best_outcome outcomes
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
