# frozen_string_literal: true

OPTIONS = {
  empty: '-',
  '-' => '-',
  x: 'x',
  'x' => 'x',
  'X' => 'x',
  o: 'o',
  'o' => 'o',
  'O' => 'o'
}.freeze

PLAYER_SYMBOL = {
  1 => 'x',
  2 => 'o'
}.freeze

# The game board
class Board
  attr_reader :boxes

  def initialize
    @boxes = Array.new(3) { Array.new(3, OPTIONS[:empty]) }
  end

  def display
    puts '    1   2   3'
    puts '  -------------'
    @boxes.each_with_index do |row, i|
      line = "#{i + 1} |"
      row.each do |box|
        line += " #{box} |"
      end
      puts line
      puts '  -------------'
    end
  end

  def set_box(value, row, column)
    @boxes[row - 1][column - 1] = value
  end

  def box(row, column)
    @boxes[row - 1][column - 1]
  end

  def box_is_empty?(row, column)
    @boxes[row - 1][column - 1] == OPTIONS[:empty]
  end

  def rows
    @boxes
  end

  def columns
    @boxes.transpose
  end

  def diagonals
    diag1 = (1..3).collect { |i| box(i, i) }
    diag2 = (1..3).collect { |i| box(i, 4 - i) }
    [diag1, diag2]
  end
end

# The gameplay
class TicTacToe
  attr_accessor :board

  def initialize
    @board = Board.new
  end

  def play
    board.display
    puts "\nLet's play tic-tac-toe!"
    round = 1
    victor = 0
    until round == 10
      player = round.odd? ? 1 : 2
      play_round(player, round)
      if round >= 5
        victor = find_victor
        break if victor.positive?
      end
      round += 1
    end
    puts victor.zero? ? "It's a tie!" : "\nCongradulations, Player #{victor}! You won!"
  end

  private

  def player_input(player, type)
    loop do
      print "Player #{player}, choose a #{type} (1 to 3): "
      result = gets.strip.to_i
      return result if result.between?(1, 3)

      puts 'Incorrect input! Try again.'
    end
  end

  def play_round(player, round)
    puts "\nRound #{round}!"
    loop do
      row = player_input(player, 'row')
      column = player_input(player, 'column')
      if board.box_is_empty?(row, column)
        board.set_box(PLAYER_SYMBOL[player], row, column)
        board.display
        break
      else
        puts 'That space is already occupied!'
      end
    end
  end

  def check_for_three(lines)
    lines.each do |line|
      return 1 if line.all? { |value| value == OPTIONS[:x] }
      return 2 if line.all? { |value| value == OPTIONS[:o] }
    end
    return 0
  end

  def find_victor
    arrays = [board.rows, board.columns, board.diagonals]
    arrays.each do |arr|
      victor = check_for_three(arr)
      return victor if victor.positive?
    end
    return 0
  end
end

new_game = TicTacToe.new
new_game.play
