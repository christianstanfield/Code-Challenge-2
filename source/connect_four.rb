require_relative 'view'
require_relative 'human_player'
require_relative 'ai_player'
require_relative 'board'

class ConnectFour
  GAME_OVER = 'game over'.freeze

  attr_reader :view, :player, :opponent, :players, :board

  def initialize
    @view     = View.new
    @player   = HumanPlayer.new
    @opponent = AiPlayer.new
    @players  = [opponent, player]
  end

  def run
    setup_game
    play_game

  rescue RuntimeError => error
    error.message == GAME_OVER ? return : raise(error)
  end

  private

  def play_game
  end

  def setup_game
    view.welcome_player

    board_dimensions = view.request_board_size
    board_dimensions[:winning_number] = view.request_winning_number
    @board = Board.new board_dimensions
    end_game unless board.valid?

    ai_strategy = view.request_ai_strategy opponent.available_strategies
    opponent.set_strategy ai_strategy
    end_game unless opponent.valid?

    player_game_piece = view.request_game_piece valid_game_pieces
    if valid_game_pieces.include? player_game_piece
      set_game_pieces player_game_piece
    else
      end_game
    end
  end

  def set_game_pieces player_game_piece
    player.game_piece = player_game_piece

    remaining_game_piece = valid_game_pieces.select do |game_piece|
      game_piece != player_game_piece
    end.pop

    opponent.game_piece = remaining_game_piece
  end

  def valid_game_pieces
    ['X', 'O']
  end

  def end_game
    view.get_it_together
    raise GAME_OVER
  end
end
