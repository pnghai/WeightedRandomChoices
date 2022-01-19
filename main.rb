require 'json'
# idea: https://www.keithschwarz.com/darts-dice-coins/
#uint256 _randomNumber,
# uint256 _lotteryId,
# uint256 paddedSize
n_stakes = rand(50..100)
prize_weights = [1,2,3,5]
stakeholders = []
weightedAddresses= {}
for i in 1..n_stakes do
  address="A#{i}"
  stakeholders.push (address)
  weightedAddresses["A#{i}"]=prize_weights.sample
end

winningSize = 15

def _split(paddedSize, winningSize, stakeholders,weightedAddresses)
  # Temporary storage for winning numbers
  sizeOfLottery = winningSize
  winningAddresses = []
  # build address list
  # Loops the size of the number of tickets in the lottery
  for i in 0..(sizeOfLottery-1) do
    # 1. initialization
    populationSize = stakeholders.length() - i - paddedSize
    
    # cumullative total
    cummulatedSum = 0;
    for k in 0..(populationSize-1) do
      cummulatedSum += weightedAddresses[stakeholders[k]]
    end
    #Create arrays Alias and Prob, each of size n.
    _Alias = Array.new(populationSize)
    _Prob = Array.new(populationSize)
    p = Array.new(populationSize)
    #Create two worklists, Small and Large.
    _Small =[]
    _Large = []

    #//Multiply each probability by n.
    for k in 0..(populationSize-1) do
        p[k] = weightedAddresses[stakeholders[k]] * populationSize;

        #// For each scaled probability pi:
        #// If pi<1, add i to Small.
        #// Otherwise (pi≥1), add i to Large.
        if (p[k] < cummulatedSum) then
            _Small.push(k)
        else
            _Large.push(k)
        end
    end

    #// (Large might be emptied first)
    while (_Small.any? && _Large.any?)
      l = _Small.pop()
      g = _Large.pop()
      _Prob[l] = p[l]
      _Alias[l]= g
      #// Set pg:=(pg+pl)−1. (This is a more numerically stable option.)
      p[g] = p[g] + p[l] - cummulatedSum
      
      if (p[g]<cummulatedSum) then
        _Small.push(g)
      else
        _Large.push(g)
      end
    end
    while (_Large.any?)
        g = _Large.pop()
        _Prob[g]=cummulatedSum
    end
    while (_Small.any?)
        l = _Small.pop()
        _Prob[l]=cummulatedSum
    end

    #// 2. Generation:
    #// Sets the winning number position to a uint16 of random hash number
    
    #// Generate a fair die roll from an n-sided die; call the side i.
    #// Generate a uniformly-random value x in the range [0,1).
    #// Return ⌊xn⌋.
    position = rand(populationSize)
    
    #// Flip a biased coin that comes up heads with probability Prob[i].
    #// Generate a uniformly-random value x in the range [0,1).
    #// If x<pheads, return "heads."
    #// If x≥pheads, return "tails."
    #// If the coin comes up "heads," return i.
    #// Otherwise, return Alias[i].
    biased = rand(cummulatedSum)
    
    if (biased < _Prob[position]) then
        winningPosition = position
    else
        winningPosition = _Alias[position]
    end
    winningAddresses[i] = stakeholders[winningPosition]
    #// Swap winningPosition with last item
    stakeholders[winningPosition] = stakeholders[populationSize-1]
    stakeholders[populationSize-1] = winningAddresses[i]
  end
  return winningAddresses
end

won = _split(0, winningSize, stakeholders,weightedAddresses)
puts "Primary:\n"
puts won
won2 = _split(15, winningSize, stakeholders,weightedAddresses)
puts "Secondary:\n"
puts won2