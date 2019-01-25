require_relative '../source/connect_four'

describe Board do
  let(:board) { described_class.new dimensions }

  describe '#winning_player' do
    let(:game_pieces) { ConnectFour.new.send :valid_game_pieces }

    context 'when a row contains winning_number of consecutive pieces' do
      let(:board_state) do
        [ ['O', nil, 'O', nil, 'X', nil, 'O'],
          ['X', nil, 'X', 'O', 'O', 'O', nil] ]
      end
      let(:dimensions) { { width: 7, height: 2, winning_number: 3, state: board_state } }

      it 'should return winning game_piece' do
        expect(board.winning_player(game_pieces)).to eq('O')
      end
    end

    context 'when a column contains winning_number of consecutive pieces' do
      let(:board_state) do
        [ ['X', nil],
          ['O', 'O'],
          [nil, nil],
          ['O', 'X'],
          ['O', 'X'],
          ['O', 'O'],
          ['X', 'O'] ]
      end
      let(:dimensions) { { width: 2, height: 7, winning_number: 3, state: board_state } }
      before(:each) do
        expect(board.send(:find_winning_row, game_pieces)).to eq(nil)
      end

      it 'should return winning game_piece' do
        expect(board.winning_player(game_pieces)).to eq('O')
      end
    end

    context 'when a diagonal contains winning_number of consecutive pieces' do
      before(:each) do
        expect(board.send(:find_winning_row, game_pieces)).to eq(nil)
        expect(board.send(:find_winning_column, game_pieces)).to eq(nil)
      end

      context 'when diagonal starts in top row' do
        let(:board_state) do
          [ ['X', nil, nil],
            ['O', 'X', 'O'],
            [nil, nil, 'X'],
            ['O', 'X', 'X'],
            ['O', 'X', nil],
            [nil, nil, 'O'],
            ['X', 'O', 'O'] ]
        end
        let(:dimensions) { { width: 3, height: 7, winning_number: 3, state: board_state } }

        it 'should return winning game_piece' do
          expect(board.winning_player(game_pieces)).to eq('X')
        end
      end

      context 'when diagonal starts in second row' do
        let(:board_state) do
          [ ['X', nil, nil],
            ['O', 'X', 'O'],
            [nil, 'O', nil],
            ['O', 'X', 'O'],
            ['O', 'X', nil],
            [nil, nil, 'O'],
            ['X', 'O', 'O'] ]
        end
        let(:dimensions) { { width: 3, height: 7, winning_number: 3, state: board_state } }

        it 'should return winning game_piece' do
          expect(board.winning_player(game_pieces)).to eq('O')
        end
      end

      context 'when diagonal starts in lowest possible row' do
        let(:board_state) do
          [ ['X', nil, nil],
            ['O', 'X', 'O'],
            [nil, nil, nil],
            ['O', 'X', 'O'],
            ['O', 'X', nil],
            [nil, 'O', 'O'],
            ['X', 'O', 'O'] ]
        end
        let(:dimensions) { { width: 3, height: 7, winning_number: 3, state: board_state } }

        it 'should return winning game_piece' do
          expect(board.winning_player(game_pieces)).to eq('O')
        end
      end

      context 'when diagonal moves down and backwards' do
        let(:board_state) do
          [ ['X', nil, nil, nil],
            ['O', 'X', 'O', 'O'],
            [nil, nil, nil, nil],
            ['O', 'X', 'O', 'X'],
            ['O', 'X', 'O', 'O'],
            [nil, 'O', nil, nil],
            ['O', 'O', 'X', 'X'] ]
        end
        let(:dimensions) { { width: 4, height: 7, winning_number: 3, state: board_state } }

        it 'should return winning game_piece' do
          expect(board.winning_player(game_pieces)).to eq('O')
        end
      end
    end

    context 'when winning_number of consecutive pieces is not found' do

      context 'first example' do
        let(:board_state) do
          [ [nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil],
            [nil, 'O', nil, nil, nil],
            [nil, 'O', 'X', nil, nil],
            [nil, 'X', 'O', nil, nil],
            ['X', 'O', 'X', 'O', nil] ]
        end
        let(:dimensions) { { width: 5, height: 7, winning_number: 4, state: board_state } }

        it 'should return nil' do
          expect(board.winning_player(game_pieces)).to eq(nil)
        end
      end

      context 'second example' do
        let(:board_state) do
          [ [nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil],
            [nil, 'O', nil, nil, 'X'],
            [nil, 'O', 'X', nil, 'O'],
            [nil, 'X', 'O', nil, 'O'],
            ['X', 'O', 'X', 'O', 'X'] ]
        end
        let(:dimensions) { { width: 5, height: 7, winning_number: 4, state: board_state } }

        it 'should return nil' do
          expect(board.winning_player(game_pieces)).to eq(nil)
        end
      end
    end
  end

  describe '#available_columns' do
    let(:board_state) do
      [ ['O', nil, 'O', nil, 'X', nil, 'O'],
        ['X', nil, 'X', 'O', 'O', 'O', nil] ]
    end
    let(:dimensions) { { width: 7, height: 2, winning_number: 3, state: board_state } }

    it 'should return the numbers of nil columns on the top row starting from 1' do
      expect(board.available_columns).to eq([2,4,6])
    end
  end

  describe '#duplicate' do
    let(:board_state) do
      [ ['O', nil, 'O'],
        ['X', nil, 'X'],
        ['X', nil, 'X'] ]
    end
    let(:dimensions) { { width: 3, height: 3, winning_number: 3, state: board_state } }

    before(:each) do
      expect(board.width).to eq(3)
      expect(board.height).to eq(3)
      expect(board.winning_number).to eq(3)
      expect(board.current_state).to eq(board_state)
    end

    it 'should return a new board with matching attributes' do
      new_board = board.duplicate
      expect(new_board.width).to eq(3)
      expect(new_board.height).to eq(3)
      expect(new_board.winning_number).to eq(3)
      expect(new_board.current_state).to eq(board_state)
    end

    it 'should not be tied in memory to original' do
      new_board = board.duplicate
      new_board.update_state 2, 'X'
      expect(new_board.current_state).to_not eq(board.current_state)
    end
  end
end
