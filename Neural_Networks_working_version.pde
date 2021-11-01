
class NeuralNetwork {
  
  int NumOfLayers;
  int[] NodesInEachLayer;
  float[][] NodeStrengths; //stores strength of each node
  float[][][] NodeConnections; //stores strength of each connection from each node
  
  NeuralNetwork(int[] LayerSizes) {
    
    NumOfLayers = LayerSizes.length; //Sets num of layers
    
    //Sets NodesInEachLayer
    NodesInEachLayer = new int[NumOfLayers];
    for (int i = 0; i < NumOfLayers; i++) {
      NodesInEachLayer[i] = LayerSizes[i];
    }
    
    //Sets NodeStrengths
    NodeStrengths = new float[NumOfLayers][];
    for (int i = 0; i < NumOfLayers; i++) {
      NodeStrengths[i] = new float[NodesInEachLayer[i]];
      for (int j = 0; j < NodesInEachLayer[i]; j++) {
        NodeStrengths[i][j] = 3;
      }
    }
    
    //Sets NodeConnections
    NodeConnections = new float[NumOfLayers][][];
    for (int i = 0; i < NumOfLayers; i++) {
      NodeConnections[i] = new float[NodesInEachLayer[i]][];
      for (int j = 0; j < NodesInEachLayer[i]; j++) {
        if (i != NodesInEachLayer.length - 1) {
          NodeConnections[i][j] = new float[NodesInEachLayer[i+1]];
          for (int k = 0; k < NodesInEachLayer[i+1]; k++) {
            NodeConnections[i][j][k] = 4;
          }
        } 
      }
     }  
   }
  
  NeuralNetwork deepCopy(int[] SizesOfLayers){
    NeuralNetwork foo = new NeuralNetwork(SizesOfLayers);
    foo.NumOfLayers = NumOfLayers;
    foo.NodesInEachLayer = NodesInEachLayer;
    
    
    for (int i = 0; i < Networks[9].getNodesInEachLayer().length-1; i++) {
      for (int j = 0; j < Networks[9].getNodesInEachLayer()[i]; j++) {
        for (int k = 0; k < Networks[9].getNodesInEachLayer()[i+1]; k++) {
          foo.NodeConnections[i][j][k] = (float) NodeConnections[i][j][k];
        }
      }
    }
  
    for (int i = 0; i < Networks[9].getNodesInEachLayer().length-1; i++) {
      for (int j = 0; j < Networks[9].getNodesInEachLayer()[i]; j++) {
        foo.NodeStrengths[i][j] = (float) NodeStrengths[i][j];
      }
    }
    
    return foo;
  }
  
  
  float[][] getNodeStrengths() {
    return NodeStrengths;  
  }
  
  float[][][] getNodeConnections() {
    return NodeConnections;
  }
  
  int[] getNodesInEachLayer() {
    return NodesInEachLayer;
  }
  
  void setNodesInEachLayer(int[] inputNodesInEachLayer) {
    NodesInEachLayer = inputNodesInEachLayer;
  }
  
  void setNodeStrengths(float[][] inputStrengths) {
    NodeStrengths = inputStrengths;
  }
  
  void setNodeConnections(float[][][] inputConnections) {
    NodeConnections = inputConnections;    
  }
  
  void randomizeAll() {
    
    //Sets NodeStrengths
    NodeStrengths = new float[NumOfLayers][];
    for (int i = 0; i < NumOfLayers; i++) {
      NodeStrengths[i] = new float[NodesInEachLayer[i]];
      for (int j = 0; j < NodesInEachLayer[i]; j++) {
        NodeStrengths[i][j] = random(0.1,1);
      }
    }
    
    //Sets NodeConnections
    NodeConnections = new float[NumOfLayers][][];
    for (int i = 0; i < NumOfLayers; i++) {
      NodeConnections[i] = new float[NodesInEachLayer[i]][];
      for (int j = 0; j < NodesInEachLayer[i]; j++) {
        if (i != NodesInEachLayer.length - 1) {
          NodeConnections[i][j] = new float[NodesInEachLayer[i+1]];
          for (int k = 0; k < NodesInEachLayer[i+1]; k++) {
            NodeConnections[i][j][k] = random(0.1,1);
          }
        }
        
      }
    }
    
    
  }
  
  float[] CalculateValues(float[] NodeInputs) {
    float[] BeforeNodes = new float[100];
    float[] AfterNodes = new float[100];
    float[][] AfterConnections = new float[100][100];
    
    for (int i = 0; i < NumOfLayers-1; i++) {//Iterates through layers
      for (int j = 0; j < NodesInEachLayer[i]; j++) { //Iterates through nodes
        AfterNodes[j] = NodeInputs[j] * NodeStrengths[i][j]; //for each node in node strengths, multiply node strength by input and set to after nodes
        for (int k = 0; k < NodesInEachLayer[i+1]; k++) { //Iterates through connections in a certain node after it has had its value multiplied
          AfterConnections[j][k] = AfterNodes[j] * NodeConnections[i][j][k]; //for each connection of each node, multiply connection strength by after nodes value and set to after connections
        }
        
      }
      
      for (int j = 0; j < NodesInEachLayer[i+1]; j++) { //for each node in the next layer, add all after connections values [node number] [iterate] and set to before nodes
            BeforeNodes[j] = 0;
            for (int k = 0; k < NodesInEachLayer[i]; k++) {
              BeforeNodes[j]+=AfterConnections[k][j]; //Takes each value slot and adds all incoming connections values from previous layer
            }
      }
    }
    
    return BeforeNodes;
    
    
  }
  
  float CalculateAndReturnHighestNodeNumber(float[] NodeInputs) {
    float highestNumber = 0;
    int correspondingNode = 0;
    float[] vals = CalculateValues(NodeInputs);
    
    for(int i = 0; i <vals.length; i++ ) {
      if (highestNumber < vals[i]) {
         highestNumber = vals[i]; 
         correspondingNode = i+1;
      }
      
    }
    
    return correspondingNode;
  }
  
  //Iterates through each number, sets an input array to all the current number, adds 1 to the score if array is successful, max score is 10
  float GradeExercise1() {
    float score = 0.0f;
    float[] inputArray = new float[NodesInEachLayer[0]];
    
    
    for (int i = 1; i <= 10; i++) { //Iterates through test values 1 through 10
      
      inputArray[i-1] = i;
      // CalculateValues(inputArray);
      
      if (CalculateAndReturnHighestNodeNumber(inputArray) != i) {
        score+=0;
        
      } else if (CalculateAndReturnHighestNodeNumber(inputArray) == i) {
        score+=1;
      }
      
    }
    
    
    return score;
  }
  
  float GradeExercise1v2() {
    float score = 0.0f;
    float[] inputArray = new float[NodesInEachLayer[0]];
    float[] resultsAfterInput = new float[NodesInEachLayer[NumOfLayers-1]];
    float[] MappedResults = new float[NodesInEachLayer[NumOfLayers-1]];
    float SmallNum;
    float LargeNum;
    
    for (int i = 1; i <= 10; i++) { //Iterates through test values 1 through 10
      
      inputArray[i-1] = 1;
      // CalculateValues(inputArray);
      
      resultsAfterInput = CalculateValues(inputArray);
      
      SmallNum = findSmallestNumber(resultsAfterInput);
      LargeNum = findLargestNumber(resultsAfterInput);
      
      for (int j = 0; i < 10; i++) {
          MappedResults[j] = map(resultsAfterInput[j], SmallNum, LargeNum, 0, 10);
          score-= .1 * MappedResults[j];
      }
      
      
      
      score+= 1.1 * MappedResults[i-1];
      
      
      inputArray[i-1] = 0;

    }
    
    return score;
  }
  
  void RandomizeSlightly(float factor1, float factor2) {
    
    //Adds random factor to NodeStrengths
    //NodeStrengths = new float[NumOfLayers][];
    for (int i = 0; i < NumOfLayers; i++) {
      //NodeStrengths[i] = new float[NodesInEachLayer[i]];
      for (int j = 0; j < NodesInEachLayer[i]; j++) {
        NodeStrengths[i][j]+=random(-factor1, factor1);
      }
    }
    
    //Adds random factor to NodeConnections
    //NodeConnections = new float[NumOfLayers][][];
    for (int i = 0; i < NumOfLayers; i++) {
      //NodeConnections[i] = new float[NodesInEachLayer[i]][];
      for (int j = 0; j < NodesInEachLayer[i]; j++) {
        if (i != NodesInEachLayer.length - 1) {
          //NodeConnections[i][j] = new float[NodesInEachLayer[i+1]];
          for (int k = 0; k < NodesInEachLayer[i+1]; k++) {
            NodeConnections[i][j][k]+=random(-factor2, factor2);
          }
        }
        
      }
    }
    
  }
  
}

float findSmallestNumber(float[] nums) {
   float smallestNum = nums[0];
   for (int i = 0; i < nums.length; i++) {
      if (nums[i] < smallestNum) {
         smallestNum = nums[i]; 
      }
   }
   return smallestNum; 
}

float findLargestNumber(float[] nums) {
   float largestNum = nums[0];
   for (int i = 0; i < nums.length; i++) {
      if (nums[i] > largestNum) {
         largestNum = nums[i]; 
      }
   }
   return largestNum; 
}

NeuralNetwork[] NeuralNetworkSelectionSort(NeuralNetwork[] networksToSort, float[] scores) {
  NeuralNetwork[] resultArray = new NeuralNetwork[networksToSort.length];
  NeuralNetwork[] UnsortedArray = networksToSort;
  float[] UnsortedScores = scores;
  float lowestCurrentScore = 100;
  int elementWithLowestScore = 0;
  int NumberOfNetworks = UnsortedScores.length;
  
  for (int i = 0; i < NumberOfNetworks; i++) { //iterates through sorting states
      for (int j = 0; j < UnsortedScores.length; j++) { //iterates through elements
        if (UnsortedScores[j] < lowestCurrentScore) {
           lowestCurrentScore = UnsortedScores[j];
           elementWithLowestScore = j;

           //print("ran");
        }
      }
      
      resultArray[i] = UnsortedArray[elementWithLowestScore];
      
      if (elementWithLowestScore != 0 && elementWithLowestScore != UnsortedArray.length-1) {
        UnsortedArray = (NeuralNetwork[]) concat((NeuralNetwork[]) subset(UnsortedArray, 0, elementWithLowestScore), (NeuralNetwork[]) subset(UnsortedArray, elementWithLowestScore+1));
        UnsortedScores = concat(subset(UnsortedScores, 0, elementWithLowestScore), subset(UnsortedScores, elementWithLowestScore+1));
        //print("a");
      } else if (elementWithLowestScore == 0) {
        UnsortedArray = (NeuralNetwork[]) subset(UnsortedArray, 1);
        UnsortedScores = subset(UnsortedScores, 1);
        //print("b");
      } else if (elementWithLowestScore == UnsortedArray.length-1) {
        UnsortedArray = (NeuralNetwork[]) subset(UnsortedArray, 0, UnsortedArray.length-1);
        UnsortedScores = subset(UnsortedScores, 0, UnsortedScores.length-1);
        //print("c");
      }
      
      lowestCurrentScore = 100;
  }
  return resultArray;
  
} 

NeuralNetwork[] NeuralNetworkSelectionSortArrayLists(NeuralNetwork[] networksToSort, float[] scores) {
  
  ArrayList<NeuralNetwork> UnsortedArray = new ArrayList<NeuralNetwork>();
  ArrayList<NeuralNetwork> arrayListResult = new ArrayList<NeuralNetwork>();
  FloatList UnsortedScores = new FloatList();
  NeuralNetwork[] resultArray = new NeuralNetwork[networksToSort.length];

  for (int i = 0; i < networksToSort.length; i++) { UnsortedArray.add(networksToSort[i]);}
  for (int i = 0; i < scores.length; i++) { UnsortedScores.append(scores[i]);}
  
  
  float lowestCurrentScore = 100;
  int elementWithLowestScore = 0;
  int NumberOfNetworks = networksToSort.length;
  
  for (int i = 0; i < NumberOfNetworks; i++) { //iterates through sorting states
      for (int j = 0; j < UnsortedScores.size(); j++) { //iterates through elements
        if (UnsortedScores.get(j) < lowestCurrentScore) {
           lowestCurrentScore = UnsortedScores.get(j);
           elementWithLowestScore = j;

        }
      }
      
      arrayListResult.add(UnsortedArray.get(elementWithLowestScore));
      
      UnsortedArray.remove(elementWithLowestScore);
      UnsortedScores.remove(elementWithLowestScore);
      
      lowestCurrentScore = 100;
  }
  
  for (int i = 0; i < networksToSort.length; i++) { resultArray[i] = arrayListResult.get(i);}
  
  return resultArray;
  
} 

NeuralNetwork copyNetwork(NeuralNetwork other ) {
         NeuralNetwork network = new NeuralNetwork(other.getNodesInEachLayer());
         network.setNodeStrengths(other.getNodeStrengths());
         network.setNodeConnections(other.getNodeConnections());
         return network;
}

NeuralNetwork[] Networks = new NeuralNetwork[10];
float[] NetworkScores = new float[10];

float[][] strengthsHolder = new float[2][10];
float[][][] connectionsHolder = new float[1][10][10]; //FIX

float[][] array1;
float[][][] array2;

int[] neuralnetworklayersizes = {10,10};

void setup() {
    
  for (int i = 0; i < 10; i++) { //creates an array of 10 neural networks with random values
    Networks[i] = new NeuralNetwork(neuralnetworklayersizes);
    Networks[i].randomizeAll();
  }

}

void draw() {
  for (int i = 0; i < 10; i++) {NetworkScores[i] = Networks[i].GradeExercise1v2();}//Grades networks
  
  Networks = NeuralNetworkSelectionSortArrayLists(Networks, NetworkScores); //Sorts networks  

  for (int i = 0; i < 10; i++) {print(Networks[i].GradeExercise1v2() + " ");} print("<--part 1"); println(" "); //Prints scores in order
  
  Networks[0] = Networks[9].deepCopy(neuralnetworklayersizes);
  //Networks[1] = Networks[9].deepCopy(neuralnetworklayersizes);
  //Networks[2] = Networks[9].deepCopy(neuralnetworklayersizes);
  //Networks[3] = Networks[9].deepCopy(neuralnetworklayersizes);
  //Networks[4] = Networks[9].deepCopy(neuralnetworklayersizes);

 //<>//
  
  //Networks[0].randomizeAll();
  //Networks[0].RandomizeSlightly(.2f,.2f);
  //Networks[1].RandomizeSlightly(.2f,.2f);
  //Networks[2].RandomizeSlightly(.2f,.2f);
  //Networks[3].RandomizeSlightly(.2f,.2f);
  //Networks[4].RandomizeSlightly(.2f,.2f);
  
  //for (int i = 0; i < 10; i++) {print(Networks[i].GradeExercise1() + " ");} print("<--part 2"); println(" "); //Prints scores in order


}
