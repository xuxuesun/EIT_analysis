function [res] = wemd(x,fs)
imf = [];
       num=0;
   while ~ismonotonic(x)
       x1 = x;
       sd = Inf;
     while (sd > 0.1) | ~isimf(x1) %#ok<OR2>
         s1 = getspline(x1);
         s2 = -getspline(-x1);
         x2 = x1-(s1+s2)/2;
         sd = sum((x1-x2).^2)/sum(x1.^2);
         x1 = x2;
     end
          imf{end+1} = x1; %#ok<AGROW>
         x          = x-x1;
         num=num+1;
%       if num==1
%          figure(3),subplot(10,1,1),plot(x1); %%%%%%%%% the intrinsic mode function
%       end 
%       if num>1
%             subplot(10,1,num),plot(x1);
%             pause;
%       end
      %    title('the EMD decomposite element');
      %    xlabel('the time axle');
%          ylabel('c')

         DD1(:,num)=x1;  %%%%%%% the EMD decompositon result every time
      %%%%%%%%%%%% the hilbert transfer of the every result, compute the
      %%%%%%%%%%%% the instantaneous frequency
%          w=hilbert(x1);
%          I=imag(w);
%          R=real(w);
%          S=atan2(I,R);
%          S=unwrap(S);  %%%%%%% modify the phase angle
%          D1(:,num)=smooth(fs*unwrap(diff(S'))/(2*pi));%%%%%%%%%%% instantaneous frequency  
   end
%           figure(4),plot(D1);
%           xlabel('time,second');
%           ylabel('frequency');
      


         NUM=num;
         for emdN=1:NUM
         %    figure(6),subplot(NUM,1,emdN),plot(DD1(:,emdN));
            w=hilbert(DD1(:,emdN));
            I=imag(w);
            R=real(w);
            S=atan2(I,R);
            S=unwrap(S);  %%%%%%% modify the phase angle
            D1(:,emdN)=smooth(fs*unwrap(diff(S'))/(2*pi));%%%%%%%%%%% instantaneous frequency

        %     figure(7),subplot(6,1,emdN),plot(D1(:,emdN));
      
         end
         res = DD1';