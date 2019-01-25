require_relative '../source/connect_four'

describe AiPlayer do
  let(:ai_player) do
    overlord = described_class.new
    overlord.game_piece = 'O'
    overlord.instance_variable_set(:@strategy, :minimax)
    overlord
  end
  let(:game_pieces) { ConnectFour.new.send :valid_game_pieces }

  describe '#select_column' do

    context 'when ai has winning move' do
      let(:board_state) do
        [ [nil, nil, nil],
          ['X', nil, 'O'],
          ['X', nil, 'O'] ]
      end
      let(:board) { Board.new(width: 3, height: 3, winning_number: 3, state: board_state) }

      it 'should return winning column' do
        column = ai_player.select_column board, game_pieces
        expect(column).to eq(3)
      end
    end

    context 'when ai does not have winning move' do

      context 'when human has winning move' do
        let(:board_state) do
          [ [nil, nil, nil],
            [nil, 'X', nil],
            ['O', 'X', 'O'] ]
        end
        let(:board) { Board.new(width: 3, height: 3, winning_number: 3, state: board_state) }

        it "should return human's winning column" do
          column = ai_player.select_column board, game_pieces
          expect(column).to eq(2)
        end
      end

      context 'when human can win on next move' do
        let(:board_state) do
          [ [nil, nil, nil],
            [nil, 'X', nil],
            ['X', 'O', 'O'] ]
        end
        let(:board) { Board.new(width: 3, height: 3, winning_number: 3, state: board_state) }

        it 'should not return column that would cause human to win' do
          column = ai_player.select_column board, game_pieces
          expect(column).to_not eq(3)
        end

        context 'when ai can win in 2 moves' do
          let(:board_state) do
            [ [nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil],
              [nil, nil, 'O', 'X', nil],
              ['O', 'X', 'X', 'O', 'O'] ]
          end
          let(:board) { Board.new(width: 5, height: 4, winning_number: 3, state: board_state) }

          it 'should return a column that sets up the win' do
            winning_colums = [1,2,3]
            column = ai_player.select_column board, game_pieces
            expect(winning_colums).to include(column)
          end
        end
      end
    end
  end
end
