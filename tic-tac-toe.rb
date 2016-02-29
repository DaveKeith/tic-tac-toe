##Data in the system
# => board
# => players
# => win conditions
# => turn_count and/or current player


require "pry"
require "set"
require "matrix"

TOTAL_SPACES = 9
spaces = [1, 2, 3, 4, 5, 6, 7, 8, 9]
threeInRow = [Set.new([1, 2, 3]), Set.new([4, 5, 6]),
Set.new([7, 8, 9]), Set.new([1, 4, 7]), Set.new([2, 5, 8]),
Set.new([3, 6, 9]), Set.new([1, 5, 9]), Set.new([3, 5, 7])]

puts "Player 1, enter your name:"
player1 = gets.chomp
puts "Do you want to be 'X' or 'O'? ('X' goes first):"
xOrO = gets.chomp.upcase
puts "add another player? ('y' for yes and any other key to play the computer):"
multiplayer = gets.chomp.downcase

if multiplayer == "y"
  puts "Player 2, enter your name:"
  player2 = gets.chomp
else
  puts "Player 2 is the computer"
  player2 = "Computer"
end

x_s = player2
o_s = player1

if xOrO == "X"
  x_s = player1
  o_s = player2
end

difficulty = 0
if x_s == "Computer" || o_s == "Computer"
  unless difficulty == 1 || difficulty == 2
    puts "Select difficulty level:\n\t1 = easy\n\t2 = hard"
    difficulty = gets.chomp.to_i
  end
end

def spaces_left(moves)
  result = TOTAL_SPACES - moves
  result
end

def win?(x_moves, o_moves, threeInRow)
  result = false

  8.times do |threes|
    if x_moves >= threeInRow[threes] ||
      o_moves >= threeInRow[threes]
      result = true
    end
  end
  result
end

def lose?(moves)
  spaces_left(moves).zero?
end

def board(x_moves, o_moves, spaces)
  9.times do |space|
    space = space-1
    if x_moves.include?(spaces[space])
      spaces[space] = "X"
    elsif o_moves.include?(spaces[space])
      spaces[space] = "O"
    end
  end
  9.times do |s|
    if s % 3 == 0
      print "\n"
    else
      print " | "
    end
    print spaces[s]
  end
  puts
end

def easy_computer(multiplayer, spaces)
  num = rand(9)
  while spaces[num] == "X" || spaces[num] == "O"
    num = rand(9)
  end
  num
end

# def corner_spaces(spaces)
#   result = 4
#   corners = [0, 2, 6, 8]
#
#   corners.each do |corner|
#     c = corner.to_i
#     if spaces[c] == "X" || spaces[c] == "O"
#       result -= 1
#     end
#   end
#   result
# end

def hard_computer(multiplayer, spaces, playerMoves, o_playerMoves, threeInRow)
  num = rand(9)

  if smart_comp(playerMoves, o_playerMoves, spaces, threeInRow) != nil
    num = smart_comp(playerMoves, o_playerMoves, spaces, threeInRow)
  else
    num = easy_computer(multiplayer, spaces)
  end
  num
end

def computer(multiplayer, spaces, difficulty, playerMoves, o_playerMoves,
  threeInRow)
  comp = hard_computer(multiplayer, spaces, playerMoves, o_playerMoves,
  threeInRow)
  if difficulty == 1
    comp = easy_computer(multiplayer, spaces)
  end
  comp = comp.to_i + 1
  comp
end

def smart_comp(playerMoves, o_playerMoves, spaces, threeInRow)
  result = nil
  next_move = Set.new

  threeInRow.each do |threes|
    u1 = nil
    u2 = nil
    u1 = playerMoves & threes
    u2 = o_playerMoves & threes
    winning = false
    threes = threes.to_a
    if u1.size == 2 && u2.size == 0
      next_move.add(threes)
      winning = true
    elsif u2.size == 2 && u1.size == 0 && !winning
      next_move.add(threes)
    end
  end

  if !next_move.empty?()
    finder = next_move.to_a
    finder.each do |i|
      i.each do |j|
        if spaces[j] != "X" || spaces[j] != "O"
          result = j.to_i
          result = result - 1
        end
      end
    end
  end

  result
end

def take_turn(x_s, o_s, moves, multiplayer, spaces, difficulty, playerMoves,
  o_playerMoves, threeInRow)
  if currentPlayer(x_s, o_s, moves) == x_s && x_s != "Computer"
    puts "#{x_s}'s turn."
    puts "Where do you want to draw an 'X' (type a number 1-9)?:"
    turn = gets.chomp.to_i
  elsif currentPlayer(x_s, o_s, moves) == o_s && o_s != "Computer"
    puts "#{o_s}'s turn."
    puts "Where do you want to draw an 'O' (type a number 1-9)?:"
    turn = gets.chomp.to_i
  else
    puts "Computer's turn"
    turn = computer(multiplayer, spaces, difficulty, playerMoves, o_playerMoves,
    threeInRow)
  end

  if multiplayer == 'y'
    until (1..9).include?(turn)
      puts "Choose a different number: "
      turn = gets.chomp.to_i
    end
  end
  turn
end

def currentPlayer(x_s, o_s, moves)
  cp = x_s
  if spaces_left(moves) % 2 == 0
    cp = o_s
  else
    cp = x_s
  end
  cp
end

def ticTacToe(x_s, o_s, spaces, multiplayer, difficulty, threeInRow)
  totalMoves = Set.new
  x_moves = Set.new
  o_moves = Set.new
  currentMove = x_moves
  opponentMove = o_moves

  until game_over(totalMoves.length, x_moves, o_moves, threeInRow)
    puts
    t = totalMoves.to_a.length
    board(x_moves, o_moves, spaces)
    if currentPlayer(x_s, o_s, t) == x_s
      currentMove = x_moves
      opponentMove = o_moves
    else
      currentMove = o_moves
      opponentMove = x_moves
    end
    turn = take_turn(x_s, o_s, t, multiplayer, spaces, difficulty, currentMove,
    opponentMove, threeInRow)
    if currentPlayer(x_s, o_s, t) == x_s
      x_moves.add(turn)
      puts "#{x_s} selects #{turn}."
    else
      o_moves.add(turn)
      puts "#{o_s} selects #{turn}."
    end
    totalMoves = x_moves + o_moves
  end
  t = totalMoves.to_a.length
  board(x_moves, o_moves, spaces)
  postmortem(t, x_moves, o_moves, x_s, o_s, threeInRow)
end

def game_over(moves, x_moves, o_moves, threeInRow)
  win?(x_moves, o_moves, threeInRow) || spaces_left(moves) == 0
end

def postmortem(moves, x_moves, o_moves, x_s, o_s, threeInRow)
  if win?(x_moves, o_moves, threeInRow) && spaces_left(moves) % 2 == 0
    puts "Congratulations #{x_s}!!!! You won!"
  elsif win?(x_moves, o_moves, threeInRow) && spaces_left(moves) % 2 == 1
    puts "Congratulations #{o_s}!!!! You won!"
  elsif
    puts "Tie!"
  end
end

ticTacToe(x_s, o_s, spaces, multiplayer, difficulty, threeInRow)
