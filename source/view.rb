class View

  def welcome_player
    reset_screen!
    puts 'Wecome to Connect Four'
  end

  def request_board_size
    puts ''
    puts 'Choose a board size'
    print 'Width: '
    width = get_user_input
    print 'Height: '
    height = get_user_input

    { width: width.to_i, height: height.to_i }
  end

  def request_winning_number
    puts ''
    print 'Choose the number of pieces in a row to win: '
    get_user_input.to_i
  end

  def request_ai_strategy available_strategies
    strategy_choices = available_strategies.map.with_index do |strategy, index|
      "#{index + 1}) #{strategy.capitalize}"
    end
    strategy_choices = strategy_choices.join(' or ')

    puts ''
    puts 'Choose a strategy for your opponent (select by number)'
    print "#{strategy_choices}: "
    get_user_input.to_i
  end

  def request_game_piece game_pieces
    game_piece_choices = game_pieces.join(' or ')

    puts ''
    puts "Choose a game piece: #{game_piece_choices}"
    get_user_input.upcase
  end

  def print_board board
    reset_screen!

    board.each.with_index do |row, row_index|
      row.each.with_index do |game_piece, column_index|
        game_piece ||= ' '
        is_last_column = column_index == row.length - 1
        is_last_column ? puts(" #{game_piece} ") : print(" #{game_piece} |")
      end

      unless is_last_row = row_index == board.length - 1
        divider_length = 3 * row.length
        divider_length += row.length - 1
        puts '-' * divider_length
      end
    end
  end

  def request_column_choice num_of_columns
    puts ''
    print "Select a column (1 - #{num_of_columns}): "
    get_user_input.to_i
  end

  def print_winner winner
    puts ''
    puts "#{winner} wins"
    puts ''
  end

  def print_game_draw
    puts ''
    puts 'Game draw'
    puts ''
  end

  def get_it_together
    puts ''
    puts '(╯°□°)╯︵ ┻━┻'
    puts ''
  end

  private

  def get_user_input
    gets.chomp
  end

  def reset_screen!
    clear_screen!
    move_to_home!
  end

  def clear_screen!
    print "\e[2J"
  end

  def move_to_home!
    print "\e[H"
  end
end
