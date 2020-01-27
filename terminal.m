function terminal(serial_)
%TERMINAL(seriall_) Matlab serial terminal
%   
%   Inputs:
%   - serial_ = Serial object [serial or Bluetooth]
%   
%   Prints incoming serial text in infinite loop. Serial object must already
%   be opened before calling this function.
%   
%   Author: Dan Oates (WPI Class of 2020)

% Initial print
clc
fprintf('Matlab Serial Terminal\n\n')

% Print loop
while true
    n = serial_.BytesAvailable;
    if n
        text = char(fread(serial_, n).');
        fprintf(text);
    end
end

end