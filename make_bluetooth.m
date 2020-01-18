function bluetooth_ = make_bluetooth(name)
%bluetooth_ = MAKE_BLUETOOTH(name)
%   Make and open bluetooth object
%   
%   Inputs:
%   - name = Device name [char]
%
%   Outputs:
%   - bluetooth_ = Bluetooth object [Bluetooth]
%   
%   To successfully open, the device must already be paired.

info = instrhwinfo('bluetooth');
for i = 1:length(info.RemoteNames)
    if strcmp(info.RemoteNames{i}, name)
        bluetooth_ = Bluetooth(info.RemoteIDs{i}, 1);
        fopen(bluetooth_);
        return
    end
end
error(['Failed to find Bluetooth with name ''' name ''''])

end