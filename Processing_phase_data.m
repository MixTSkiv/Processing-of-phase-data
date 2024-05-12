C11 = readmatrix('C1vera_speed00001.txt');
C21 = readmatrix('C1vera_speed00002.txt');
C31 = readmatrix('C1vera_speed00003.txt');
%C41 = readmatrix('C1vera00006.txt');
%C51 = readmatrix('C1vera00007.txt');

C12 = readmatrix('C2vera_speed00001.txt');
C22 = readmatrix('C2vera_speed00002.txt');
C32 = readmatrix('C2vera_speed00003.txt');
%C42 = readmatrix('C2vera00006.txt');
%C52 = readmatrix('C2vera00007.txt');

C13 = readmatrix('C3vera_speed00001.txt');
C23 = readmatrix('C3vera_speed00002.txt');
C33 = readmatrix('C3vera_speed00003.txt');
%C43 = readmatrix('C3vera00006.txt');
%C53 = readmatrix('C3vera00007.txt');

C14 = readmatrix('C4vera_speed00001.txt');
C24 = readmatrix('C4vera_speed00002.txt');
C34 = readmatrix('C4vera_speed00003.txt');
%C44 = readmatrix('C4vera00006.txt');
%C54 = readmatrix('C4vera00007.txt');


Amp1 = rmmissing(C31(:,2));
Amp2 = rmmissing(C32(:,2));
Amp3 = rmmissing(C33(:,2));
Amp4 = rmmissing(C34(:,2));
time1 = rmmissing(C31(:,1));
time2 = rmmissing(C32(:,1));
time3 = rmmissing(C33(:,1));
time4 = rmmissing(C34(:,1));


%Нахождение фазы сигнала из квадратуры
phase_1 = atan(Amp1./Amp2);
phase_2 = atan(Amp3./Amp4);

%Разворот фазы
wphase_1 = phase_1;
wphase_2 = phase_2;

n=1;
counter1=0;
counter2=0;

while n < 25001
    if      (phase_1(n) - phase_1(n+1)) >= pi
        wphase_1(n) = phase_1(n) + counter1;
        counter1 = counter1 + (phase_1(n) - phase_1(n+1));
        wphase_1(n+1) = phase_1(n+1) + counter1;
    elseif phase_1(n+1) - phase_1(n) >= pi
        wphase_1(n) = wphase_1(n) + counter1;
        counter1 = counter1 - (phase_1(n+1) - phase_1(n));
        wphase_1(n+1) = phase_1(n+1) + counter1;
    else
        wphase_1(n) = wphase_1(n) + counter1;
    end
    
    if      (phase_2(n) - phase_2(n+1)) >= pi
        wphase_2(n) = wphase_2(n) + counter2;
        counter2 = counter2 + (phase_2(n) - phase_2(n+1));
        wphase_2(n+1) = wphase_2(n+1) + counter2;
    elseif  (phase_2(n+1) - phase_2(n)) >= pi
        wphase_2(n) = wphase_2(n) + counter2;
        counter2 = counter2 - (phase_2(n+1) - phase_2(n));
        wphase_2(n+1) = wphase_2(n+1) + counter2;
    else
        wphase_2(n) = wphase_2(n) + counter2;
    end
    
    n = n + 1;
end

% Вычисление электронной плотности плазмы 
lambda1 = 1550*10^(-9);
lambda2 = 532*10^(-9);

Ne = (wphase_2*lambda2 - wphase_1*lambda1)/...
    (4.49*10^(-14)*2*pi*((lambda2*lambda2)-(lambda1*lambda1)));
P = wphase_2*(lambda2/lambda1)*(0.3) - wphase_1;

% Построение графиков 
hold on
plot(time1, wphase_1);
plot(time3, wphase_2);
title('Эксперимент №1');
xlabel('time, с');
ylabel('Phase, рад');
legend('1550 нм','532 нм')
hold off

