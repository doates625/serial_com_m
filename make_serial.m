function serial_ = make_serial(port, baud)
%serial_ = MAKE_SERIAL(port, baud)
%   Create and open serial port
%   
%   Inputs:
%   - port = Port name [char, e.g. 'COM3']
%   - baud = Baud rate [int, e.g. 115200]
%   
%   Outputs:
%   - serial_ = Serial object [serial]
%   
%   When port is set to 'auto', the port is auto-detected.

% Auto-detection
if strcmp(port, 'auto')
    info = instrhwinfo('Serial');
    if isempty(info.AvailableSerialPorts)
        error('No serial ports available.')
    end
    port = info.AvailableSerialPorts{1};
end

% Create and open port
serial_ = serial(port, 'BaudRate', baud);
fopen(serial_);

end