require "pry"
require "set"

spaces = [1, 2, 3, 4, 5, 6, 7, 8, 9]
threeInRow = [Set.new([1, 2, 3]), Set.new([4, 5, 6]),
Set.new([7, 8, 9]), Set.new([1, 4, 7]), Set.new([2, 5, 8]),
Set.new([3, 6, 9]), Set.new([1, 5, 9]), Set.new([3, 5, 7])]

puts "Player 1, enter your name:"
player1 = gets.chomp
puts "Enter 'X' if you want to be 'X'? ('X' goes first):"
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

def board(x_moves, o_moves, spaces)
  9.times do |space|
    if x_moves.include?(spaces[space])
      spaces[space] = "X"
    elsif o_moves.include?(spaces[space])
      spaces[space] = "O"
    end

    if space % 3 == 0
      print "\n"
    else
      print " | "
    end
    print spaces[space]
  end
  puts
end

def computer(spaces)
  num = rand(9)
  while spaces[num] == "X" || spaces[num] == "O"
    num = rand(9)
  end
  num
end

def take_turn(x_s, o_s, moves, spaces, playerMoves, threeInRow)
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
    turn = computer(spaces)
  end

  if currentPlayer(x_s, o_s, moves) != "Computer"
    until (1..9).include?(turn)
      puts "Choose a different number: "
      turn = gets.chomp.to_i
    end
  end
  turn
end

def currentPlayer(x_s, o_s, moves)
  moves % 2 == 0? cp = o_s : cp = x_s
  cp
end

def ticTacToe(x_s, o_s, spaces, threeInRow)
  x_moves = Set.new
  o_moves = Set.new
  currentMove = x_moves
  available_moves = Set.new(spaces)

  until game_over(x_moves, o_moves, threeInRow)
    puts
    available = available_moves.to_a.length
    board(x_moves, o_moves, spaces)
    cp = currentPlayer(x_s, o_s, available)
    if cp == x_s
      currentMove = x_moves
    else
      currentMove = o_moves
    end
    turn = take_turn(x_s, o_s, available, spaces, currentMove, threeInRow)
    if cp == x_s && available_moves.include?(turn)
      x_moves.add(turn)
      puts "#{x_s} selects #{turn}."
    elsif available_moves.include?(turn)
      o_moves.add(turn)
      puts "#{o_s} selects #{turn}."
    end
    available_moves.delete(turn)
  end
  board(x_moves, o_moves, spaces)
  postmortem(x_moves, o_moves, cp, threeInRow)
end

def game_over(x_moves, o_moves, threeInRow)
  total_moves = x_moves + o_moves
  t = total_moves.length
  win?(x_moves, o_moves, threeInRow) || t == 9
end

def postmortem(x_moves, o_moves, current_player, threeInRow)
  total_moves = x_moves + o_moves
  t = total_moves.length
  if win?(x_moves, o_moves, threeInRow)
    puts "Congratulations #{current_player}!!!! You won!"
  elsif t == 9
    puts "Tie!"
  end
end

ticTacToe(x_s, o_s, spaces, threeInRow)
