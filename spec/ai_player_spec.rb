require_relative '../source/connect_four'

describe AiPlayer do
  let(:ai_player) do
    overlord = described_class.new
    overlord.game_piece = 'O'
    overlord.instance_variable_set(:@strategy, :minimax)
    overlord
  end
  let(:human_player) do
    human = HumanPlayer.new
    human.game_piece = 'X'
    human
  end
  let(:players) { [ai_player, human_player] }

  describe '#select_column' do

    context 'when ai has winning move' do
      let(:board_state) do
        [ [nil, nil, nil],
          ['X', nil, 'O'],
          ['X', nil, 'O'] ]
      end
      let(:board) { Board.new(width: 3, height: 3, winning_number: 3, state: board_state) }

      it 'should return winning column' do
        column = ai_player.select_column board, players
        expect(column).to eq(3)
      end
    end

    context 'when ai does not have winning move' do

      context 'when human has winning move' do
        let(:board_state) do
          [ [nil, nil, nil],
            ['X', nil, nil],
            ['X', 'O', 'O'] ]
        end
        let(:board) { Board.new(width: 3, height: 3, winning_number: 3, state: board_state) }

        it "should return human's winning column" do
          column = ai_player.select_column board, players
          expect(column).to eq(1)
        end
      end
    end
  end
end
