#include "DspFilters/Dsp.h"
#include "DspFilters/Butterworth.h"
#include "DspFilters/Filter.h"
//#include <sstream>
#include <iostream>
#include <stdlib.h>
//#include <iomanip>
//#include <random.h>

int numSamples=25;

float* audioData[2];


//audioData[0] = new float[numSamples];
//audioData[1] = new float[numSamples];


// void UsageExamples()

// {
// void UsageExamples ()
// {
//   // create a 2-channel Butterworth Band Pass of order 4,
//   // with parameter smoothing and apply it to the audio data.
//   // Output samples are generated using Direct Form II realization.
//   {
//     Dsp::Filter* f = new Dsp::SmoothedFilterDesign
//       <Dsp::Butterworth::Design::BandPass <4>, 2, Dsp::DirectFormII> (1024);
//     Dsp::Params params;
//     params[0] = 44100; // sample rate
//     params[1] = 4; // order
//     params[2] = 4000; // center frequency
//     params[3] = 880; // band width
//     f->setParams (params);
//     f->process (numSamples, audioData);
//   }
// }
// }

int main()
{
  int i;

  audioData[0] = new float[numSamples];
  audioData[1] = new float[numSamples];


  for(i=0;i<numSamples;i++){
      //     audioData[0][i]=(rand()%10)-5;
      *(audioData[0]+i)=(rand()%10);
      *(audioData[1]+i)=(rand()%10);
      std::cout << *(audioData[0]+i) << ", ";
  }

  std::cout << std::endl;

  // create a 2-channel Butterworth Low Pass of order 1,
  // with parameter smoothing and apply it to the audio data.
  // Output samples are generated using Direct Form II realization.
     Dsp::Filter* f = new Dsp::SmoothedFilterDesign
       <Dsp::Butterworth::Design::HighPass <1>, 2, Dsp::DirectFormII> (1024);
     Dsp::Params params;
     params[0] = 10; // sample rate
     params[1] = 1; // order
     params[2] = 4; // cutoff frequency
     
     f->setParams (params);
     f->process (numSamples, audioData);


     for(i=0;i<numSamples;i++){
       std::cout << *(audioData[0]+i) << ", ";
     }
     std::cout << std::endl;
     
     return 0; 
}
