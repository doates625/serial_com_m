function n = sizeof(arg)
%SIZEOF Number of bytes in C data type
%   
%   n = SIZEOF(class_) Returns size of class string
%   n = SIZEOF(var_) Returns size of variable
%   
%   Valid input types:
%   - Signed ints (int8, int16, int32, int64)
%   - Unsigned ints (uint8, uint16, uint32, uint64)
%   - Floating points: {single, double}
%   
%   Author: Dan Oates (WPI Class of 2020)

% Convert to class
if ~isa(arg, 'char')
    arg = class(arg);
end

% Class conditions
switch arg
    case {'int8', 'uint8'}, n = 1;
    case {'int16', 'uint16'}, n = 2;
    case {'int32', 'uint32', 'single'}, n = 4;
    case {'int64', 'uint64', 'double'}, n = 8;
    otherwise, error(['Invalid type: ''' arg ''''])
end

end