#uint256 _randomNumber,
# uint256 _lotteryId,
# uint256 paddedSize
stakeholders[]
weightedAddresses= {}
winningSize = 15
def _split(paddedSize)
  # Temporary storage for winning numbers
  sizeOfLottery = winningSize;
  winningAddresses = [];
  # build address list
  // Loops the size of the number of tickets in the lottery
  for (i = 0; i < sizeOfLottery; i++) do
    # 1. initialization
    populationSize = stakeholders.length() - i - paddedSize
    
    # cumullative total
    cummulatedSum = 0;
    for k in 1..populationSize do
      cummulatedSum += weightedAddresses[stakeholders[k-1]
    end
    #Create arrays Alias and Prob, each of size n.
    _Alias = []
    _Prob = []
    p = []
    #Create two worklists, Small and Large.
    _Small =[]
      _Large = []

    #//Multiply each probability by n.
    for k in 1..populationSize do
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
      _Prop[l] = p[l]
      _Alias[l]= g
      #// Set pg:=(pg+pl)−1. (This is a more numerically stable option.)
      p[g] = p[g] + p[l] - cummulatedSum
      
      if (p[g]<1) then
        _Small.push(g)
      else
        _Large.push(g)
      end
    end
    while (_Large.any?)
        g = _Large.pop()
        _Prob[g]=1
    end
    while (_Small.any?)
        l = _Small.pop()
        _Prob[l]=1
    end

    #// 2. Generation:
    numberRepresentation = uint256(hashOfRandom)
    #// Sets the winning number position to a uint16 of random hash number
    
    #// Generate a fair die roll from an n-sided die; call the side i.
    #// Generate a uniformly-random value x in the range [0,1).
    #// Return ⌊xn⌋.
    position = numberRepresentation.mod(populationSize)
    
    #// Flip a biased coin that comes up heads with probability Prob[i].
    #// Generate a uniformly-random value x in the range [0,1).
    #// If x<pheads, return "heads."
    #// If x≥pheads, return "tails."
    #// If the coin comes up "heads," return i.
    #// Otherwise, return Alias[i].
    biased = numberRepresentation.mod(cummulatedSum);
    winningPosition;
    
    if (biased < Prob[position]) then
        winningPosition = position;
    else
        winningPosition = Alias[position]
    end
    winningAddresses[i] = stakeholders[winningPosition]
    #// Swap winningPosition with last item
    stakeholders[winningPosition] = stakeholders[populationSize-1]
    stakeholders[populationSize-1] = winningAddresses[i]
  end
  return winningAddresses
end