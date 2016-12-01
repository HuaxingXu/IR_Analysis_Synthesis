%* == MakeGolaySequence.m == 
%Generates a time series of interleaved Golay-complementary sequences (i.i. ABABABAB.... etc.) and saves it to a .wav file

%* == Specify Inputs ==
%** Sampling frequency in Hz 
%must be compatible with playback/recording hardware
fs=44100;       
%** Desired length of a single Golay sequence in s.  
%This should be longer than any IRs to be recorded.
Lg=6;
%** Number of repetitions
% Noise floor in IRs due to background noise and electrical noise should decrease as \sqrt{Nrp}
Nrp=8;
%** Bits per sample
%must be compatible with playback/recording hardware
Bts=24;

%* == Generate Golay sequence ==
%** Specify short golay sequences 
a = [1 1];
b = [1 -1];
%** Catenate iteratively to create longer sequences
while length(a)<Lg*fs
    olda = a;
    oldb = b;
    a = [olda oldb];
    b = [olda -oldb];
end
%** Collate into an interleaved vector
ab=[a b]; oab=ab;
for jrp=1:(Nrp-1)
    ab=[ab oab];
end

%* == Write file (Scaling by 0.9999 suppresses a warning message about clipping) ==
%** Specify Filename
fnm=sprintf('golay_%dkHz_N%d_%dmin_%dbits.wav',round(fs/1e3),round(log2(length(a))),round(length(ab)/fs/60),Bts);
%** Write Audio
audiowrite(fnm,ab*0.9999,fs,'BitsPerSample',Bts);