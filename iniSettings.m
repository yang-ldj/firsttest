%{
  ------------------ ϵͳ�������� -----------------------------------------

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function    settings  = iniSettings()

% ����
settings.c            = 3e8;                         % ����

%--------------------- �źŲ������� ---------------------------------------
settings.fc           = 1575.42e6;                   % �ز�Ƶ��
settings.lambda       = settings.c/settings.fc;      % �źŲ���
settings.freCode      = 1.023e6;                     % ���������
settings.CodeLength   = 10230;                       % ����볤��
settings.freScA       = 1*1.023e6;                   % ���ز�A��Ƶ��
settings.freScB       = 6*1.023e6;                   % ���ز�B��Ƶ��

%--------------------- ���ջ��������� -------------------------------------
settings.IF           = 10e6;                        % ����Ƶ��
settings.fs           = 96*1.023e6;                  % ����Ƶ��
settings.ts           = 1/settings.fs;               % ��������
settings.N            = 512;                         % FFT����
settings.M            = 50;                          % �ֶ���
settings.SampleNum    = settings.N*settings.M;       % �źų��ȣ�����������
settings.NumPerCode   = ceil(settings.fs ...
                      / settings.freCode);           % ÿ����Ƭ��������
settings.NumPerScode  = settings.CodeLength ...
                      * settings.NumPerCode;         % ÿ�������������
% ������Ϊ��Ƶ�����������Ƭ����������������ͬ

%--------------------- ���泡������ ---------------------------------------
settings.SigNum       = 1;                           % �ź���

end