require_relative '../source/connect_four'

describe Board do
  let(:board) { described_class.new dimensions }

  describe '#winning_player' do
    let(:player) do
      human_player = HumanPlayer.new
      human_player.game_piece = 'X'
      human_player
    end
    let(:opponent) do
      ai_player = AiPlayer.new
      ai_player.game_piece = 'O'
      ai_player
    end
    let(:players) { [player, opponent] }

    context 'when a row contains winning_number of consecutive pieces' do
      let(:dimensions) { { width: 7, height: 2, winning_number: 3 } }
      before(:each) do
        allow(board).to receive(:initial_board_state).and_return(
          [ ['O', nil, 'O', nil, 'X', nil, 'O'],
            ['X', nil, 'X', 'O', 'O', 'O', nil]
          ]
        )
      end

      it 'should return winning game_piece' do
        expect(board.winning_player(players)).to eq('O')
      end
    end

    context 'when a column contains winning_number of consecutive pieces' do
      let(:dimensions) { { width: 2, height: 7, winning_number: 3 } }
      before(:each) do
        allow(board).to receive(:initial_board_state).and_return(
          [ ['X', nil],
            ['O', 'O'],
            [nil, nil],
            ['O', 'X'],
            ['O', 'X'],
            ['O', 'O'],
            ['X', 'O']
          ]
        )
        expect(board.send(:find_winning_row, players)).to eq(nil)
      end

      it 'should return winning game_piece' do
        expect(board.winning_player(players)).to eq('O')
      end
    end

    context 'when a diagonal contains winning_number of consecutive pieces' do

      context 'when diagonal starts in top row' do
        let(:dimensions) { { width: 3, height: 7, winning_number: 3 } }
        before(:each) do
          allow(board).to receive(:initial_board_state).and_return(
            [ ['X', nil, nil],
              ['O', 'X', 'O'],
              [nil, nil, 'X'],
              ['O', 'X', 'X'],
              ['O', 'X', nil],
              [nil, nil, 'O'],
              ['X', 'O', 'O']
            ]
          )
          expect(board.send(:find_winning_row, players)).to eq(nil)
          expect(board.send(:find_winning_column, players)).to eq(nil)
        end

        it 'should return winning game_piece' do
          expect(board.winning_player(players)).to eq('X')
        end
      end

      context 'when diagonal starts in second row' do
        let(:dimensions) { { width: 3, height: 7, winning_number: 3 } }
        before(:each) do
          allow(board).to receive(:initial_board_state).and_return(
            [ ['X', nil, nil],
              ['O', 'X', 'O'],
              [nil, 'O', nil],
              ['O', 'X', 'O'],
              ['O', 'X', nil],
              [nil, nil, 'O'],
              ['X', 'O', 'O']
            ]
          )
          expect(board.send(:find_winning_row, players)).to eq(nil)
          expect(board.send(:find_winning_column, players)).to eq(nil)
        end

        it 'should return winning game_piece' do
          expect(board.winning_player(players)).to eq('O')
        end
      end

      context 'when diagonal starts in lowest possible row' do
        let(:dimensions) { { width: 3, height: 7, winning_number: 3 } }
        before(:each) do
          allow(board).to receive(:initial_board_state).and_return(
            [ ['X', nil, nil],
              ['O', 'X', 'O'],
              [nil, nil, nil],
              ['O', 'X', 'O'],
              ['O', 'X', nil],
              [nil, 'O', 'O'],
              ['X', 'O', 'O']
            ]
          )
          expect(board.send(:find_winning_row, players)).to eq(nil)
          expect(board.send(:find_winning_column, players)).to eq(nil)
        end

        it 'should return winning game_piece' do
          expect(board.winning_player(players)).to eq('O')
        end
      end

      context 'when diagonal moves down and backwards' do
        let(:dimensions) { { width: 4, height: 7, winning_number: 3 } }
        before(:each) do
          allow(board).to receive(:initial_board_state).and_return(
            [ ['X', nil, nil, nil],
              ['O', 'X', 'O', 'O'],
              [nil, nil, nil, nil],
              ['O', 'X', 'O', 'X'],
              ['O', 'X', 'O', 'O'],
              [nil, 'O', nil, nil],
              ['O', 'O', 'X', 'X']
            ]
          )
          expect(board.send(:find_winning_row, players)).to eq(nil)
          expect(board.send(:find_winning_column, players)).to eq(nil)
        end

        it 'should return winning game_piece' do
          expect(board.winning_player(players)).to eq('O')
        end
      end
    end

    context 'when winning_number of consecutive pieces is not found' do

      context 'first example' do
        let(:dimensions) { { width: 5, height: 7, winning_number: 4 } }
        before(:each) do
          allow(board).to receive(:initial_board_state).and_return(
            [ [nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil],
              [nil, 'O', nil, nil, nil],
              [nil, 'O', 'X', nil, nil],
              [nil, 'X', 'O', nil, nil],
              ['X', 'O', 'X', 'O', nil]
            ]
          )
          expect(board.send(:find_winning_row, players)).to eq(nil)
          expect(board.send(:find_winning_column, players)).to eq(nil)
        end

        it 'should return nil' do
          expect(board.winning_player(players)).to eq(nil)
        end
      end

      context 'second example' do
        let(:dimensions) { { width: 5, height: 7, winning_number: 4 } }
        before(:each) do
          allow(board).to receive(:initial_board_state).and_return(
            [ [nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil],
              [nil, 'O', nil, nil, 'X'],
              [nil, 'O', 'X', nil, 'O'],
              [nil, 'X', 'O', nil, 'O'],
              ['X', 'O', 'X', 'O', 'X']
            ]
          )
          expect(board.send(:find_winning_row, players)).to eq(nil)
          expect(board.send(:find_winning_column, players)).to eq(nil)
        end

        it 'should return nil' do
          expect(board.winning_player(players)).to eq(nil)
        end
      end
    end
  end

  describe '#available_columns' do
    let(:dimensions) { { width: 7, height: 2, winning_number: 3 } }
    before(:each) do
      allow(board).to receive(:initial_board_state).and_return(
        [ ['O', nil, 'O', nil, 'X', nil, 'O'],
          ['X', nil, 'X', 'O', 'O', 'O', nil]
        ]
      )
    end

    it 'should return the numbers of nil columns on the top row starting from 1' do
      expect(board.available_columns).to eq([2,4,6])
    end
  end
end
