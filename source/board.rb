class Board

  attr_reader :width, :height, :winning_number, :current_state

  def initialize dimensions
    @width          = dimensions[:width]
    @height         = dimensions[:height]
    @winning_number = dimensions[:winning_number]
    @current_state  = dimensions[:state] || initial_board_state
  end

  def update_state column_choice, game_piece
    return false unless column_choice_valid? column_choice

    column_index = column_choice - 1
    column = get_column column_index
    bottom_available_row = height - 1
    updated_successfully = false

    until updated_successfully || bottom_available_row < 0
      if column[bottom_available_row] == nil
        set_state bottom_available_row, column_index, game_piece
        updated_successfully = true
      else
        bottom_available_row -= 1
      end
    end

    updated_successfully
  end

  def full?
    current_state.flatten.compact.length == current_state.flatten.length
  end

  def available_columns
    top_row = current_state.first
    empty_columns = []

    top_row.each.with_index do |column, index|
      empty_columns << index + 1 if column.nil?
    end

    empty_columns
  end

  def winning_player players
    if winner = find_winning_row(players)
      winner
    elsif winner = find_winning_column(players)
      winner
    elsif winner = find_winning_diagonal(players)
      winner
    end
  end

  def valid?
    dimensions_valid? && winning_number_valid?
  end

  def duplicate
    self.class.new(
      width: width,
      height: height,
      winning_number: winning_number,
      state: current_state.dup.map(&:dup)
    )
  end

  private

  def find_winning_row players
    find_winning_player current_state, players
  end

  def find_winning_column players
    find_winning_player current_state.transpose, players
  end

  def find_winning_diagonal players
    possible_winning_rows_moving_down = (0..height - winning_number).to_a

    diagonals = search_diagonals_moving_forward possible_winning_rows_moving_down
    winner = find_winning_player diagonals, players
    return winner if winner

    diagonals = search_diagonals_moving_backwards possible_winning_rows_moving_down
    find_winning_player diagonals, players
  end

  def search_diagonals_moving_forward row_indexs
    possible_winning_columns_moving_down_forward = (0..width - winning_number).to_a
    diagonals = []

    row_indexs.each do |row_index|
      possible_winning_columns_moving_down_forward.each do |column_index|
        diagonal = []

        winning_number.times do |diagonal_index|
          diagonal << current_state[row_index + diagonal_index][column_index + diagonal_index]
        end

        diagonals << diagonal
      end
    end
    diagonals
  end

  def search_diagonals_moving_backwards row_indexs
    possible_winning_columns_moving_down_backwards = (0 + winning_number - 1..width - 1).to_a
    diagonals = []

    row_indexs.each do |row_index|
      possible_winning_columns_moving_down_backwards.each do |column_index|
      diagonal = []

        winning_number.times do |diagonal_index|
          diagonal << current_state[row_index + diagonal_index][column_index - diagonal_index]
        end

        diagonals << diagonal
      end
    end
    diagonals
  end

  def find_winning_player board_state, players
    board_state.each do |row|
      player_pieces = players.map { |player| [player.game_piece, []] }.to_h
      previous_played_piece = nil

      row.each do |game_piece|
        if game_piece
          if game_piece == previous_played_piece
            consecutive_number = player_pieces[game_piece].pop
            player_pieces[game_piece] << consecutive_number + 1
          else
            player_pieces[game_piece] << 1
          end
        end

        previous_played_piece = game_piece
      end

      player_pieces.each do |game_piece, consecutive_numbers|
        return game_piece if consecutive_numbers.any? { |num| num >= winning_number }
      end
    end
    nil # no winner found
  end

  def set_state row, column, game_piece
    @current_state[row][column] = game_piece
  end

  def get_column index
    current_state.transpose[index]
  end

  def column_choice_valid? column_choice
    available_columns.include? column_choice
  end

  def initial_board_state
    Array.new(height) { Array.new(width) }
  end

  def dimensions_valid?
    [width, height, winning_number].all? do |value|
      value.is_a?(Integer) && value > 1
    end
  end

  def winning_number_valid?
    winning_number <= [width, height].min
  end
end
