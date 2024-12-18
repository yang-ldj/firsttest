%{
  ------------------ ��������B1C����Ƶ�ź� --------------------------------
  (1) S_B1C(t) = S_B1C_data(t) + 1i*S_B1C_pilot(t)
  --- S_B1C_data(t) = (1/2)*D_B1C_data(t)*C_B1C_data(t)*sc_B1C_data(t)
  --- S_B1C_pilot(t) = sqrt(3/4)*C_B1C_pilot(t)*sc_B1C_pilot(t)

  (2) ���ݷ����͵�Ƶ�����Ĳ�������е��볤����10230����Ƭ���ʶ���1.023MHz
  
  (3) sc_B1C_data(t) = sign(sin(2*pi*f_sc_bic_a*t))
  --- f_sc_bic_a = 1.023MHz
  
  (4) sc_B1C_pilot(t) = sqrt(29/33)*sign(sin(2*pi*f_sc_b1c_a*t)) ...
  --- - 1i*sqrt(4/33)*sign(sin(2*pi*f_sc_b1c_b*t))

  -------------------------------------------------------------------------
  ʹ��sign���������ز�ʱ�ᵼ������λ��ͻ��
  --- ��������Ĺ�ϵ��
  --- sign(sin(2*pi*fa*t))����Ƭ����ǲ�����ȵ�1/2
  --- sign(sin(2*pi*fb*t))����Ƭ����ǲ�����ȵ�1/12
  --- ���Ը��������ϵ��������ȷ�ı�����ϵ�������ز�
  
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function   Signal = GenB1CSig()

% ȫ�ֱ���
global   settings;

% ������Ƶ���������
NumCs    = ceil(settings.SampleNum/settings.NumPerCode/settings.CodeLength);

% ����������������ʱ��
NumSamp  = NumCs*settings.CodeLength*settings.NumPerCode;
t        = (1:NumSamp).*settings.ts;

% ���ز���Ƭ���
NumFreA  = ceil(settings.NumPerCode/2);
NumFreB  = ceil(settings.NumPerCode/12);

% ����źų�ʼ��
Signal   = zeros(settings.SigNum, settings.SampleNum);

for index = 1:settings.SigNum
    
    % �������ݷ���������
    CM_data  = genMaincode_data(index);
    
    % ��CM_data�е�0ӳ�䵽-1
    CM_data(CM_data == 0) = -1;
    
    % �����ݷ��������������Ԫ��չ
    label    = ceil((1:settings.NumPerCode*settings.CodeLength) ...
             ./settings.NumPerCode);
         
    CM_dataL = CM_data(label);
    
    % ����Ƶ����������ظ����Ա��������������1����Ƶ������ʱ����
    CM_dataL = repmat(CM_dataL, 1, NumCs);
    
    % �������ݷ��������ز�
    % Sc_data  = sign(sin(2*pi*settings.freScA.*t));
    sc_data  = [ones(1,NumFreA), -ones(1, NumFreA)];
    % ��һ����Ƭ���ȵ����ز�����������չ
    Sc_data  = repmat(sc_data, 1, NumCs*settings.CodeLength);
    
    % ��򹹳����ݷ���
    S_data   = 0.5.*CM_dataL.*Sc_data;
    
    % ----------------- ���쵼Ƶ�������� ----------------------------------
    % ������Ƶ����������
    CM_pilot = genMaincode_pilot(index);
    CM_pilot(CM_pilot == 0) = -1;
    
    % �Ե�Ƶ���������������Ԫ��չ
    label    = ceil((1:settings.NumPerCode*settings.CodeLength) ...
             ./settings.NumPerCode);
    
    CM_pilL  = CM_pilot(label);
    % ͬ���أ��Ե�Ƶ�������������������չ
    CM_pilL  = repmat(CM_pilL, 1, NumCs);
    
    % ������Ƶ���������� 
    CS_pilot = genSubcode_pilot(index);
    CS_pilot(CS_pilot == 0) = -1;
    
    % ��Ƶ����һ������ĳ�����һ�����ڵ�����
    % ��������һ�㲻�ᳬ��1800�����ڵ������ź� --- NumSamp < 1800*10230*NumPerCode
    % ��������ݲ���������������ظ�
    label    = ceil((1:NumSamp)./settings.NumPerScode);
    
    CS_pilL  = CS_pilot(label);
    
    % ��Ƶ����������������򹹳ɵ�Ƶ���������
    C_b1c_pl = CM_pilL.*CS_pilL;
    
    % ������Ƶ���������ز�
    sc_pil_a = [ones(1,NumFreA), -ones(1, NumFreA)];
    Sc_pil_a = repmat(sc_pil_a, 1, NumCs*settings.CodeLength);
    
    sc_pil_b = [ones(1, NumFreB), -ones(1, NumFreB)];
    Sc_pil_b = repmat(sc_pil_b, 1, 6*NumCs*settings.CodeLength);
    
    Sc_pilot = sqrt(29/33).*Sc_pil_a - 1i.*sqrt(4/33).*Sc_pil_b;
    
    % ��Ƶ��������������ز���򹹳ɵ�Ƶ����
    S_pilot  = sqrt(3/4).*C_b1c_pl.*Sc_pilot;
    
    %----------------------------------------------------------------------
    % B1C�źŵĸ�����
    S_b1c    = S_data + 1i.*S_pilot;
    
    % ��Ƶ�ز�
    Carr     = exp(1i*2*pi*settings.IF(index).*t);
    
    % ���������ز���˲��ض�
    temSig   = S_b1c.*Carr;
    Signal(index,:) = temSig(1:settings.SampleNum);
        
end % for index = 1:settings.SigNum

return