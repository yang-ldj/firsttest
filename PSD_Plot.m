%{
  ----------------- �����źŵĹ������ܶ�(PSD) -----------------------------
  1��������ʵ�ָ����ź��Ƿ�����Զ�����legend�أ�
  --- ��ʱʹ���ֶ��޸İ�

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function   [] = PSD_Plot(Xs)
% ȫ�ֱ���
global   settings

% �ֶγ��� --- ͬʱ��Ϊ���������fft�ĵ���
nfft     = 1024;

% �Ӵ�
window   = hanning(nfft);

% �ص����ݵ��� --- �ص�50%
noverlop = nfft/2;
   
% ʹ��welch�������������źŵ�PSD
[Pxs, f] = pwelch(Xs, window, noverlop, nfft, settings.fs);

% ��Ƶ�׿̶Ƚ��а���
f        = -settings.fs/2 + f;
   
plot(f./1e6, 10*log10(fftshift(Pxs)));
grid on
hold on
xlabel('Ƶ�� [MHz]');
ylabel('�����ܶ� [dBW/Hz]');
title('�������ܶ�');

return