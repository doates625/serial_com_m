classdef SerialServer < handle
    %SERIALSERVER Class for exchanging and processing serial data packets
    %   
    %   This class implements a bare-bones serial packet protocol system
    %   for use with Arduinos. A serial server is attached to one serial
    %   port and consists of TX and RX message definitions. A message
    %   definition consists of:
    %   
    %   - Message ID (1 byte)
    %   - Length of data (1 byte)
    %   - TX callback function (TX only)
    %   - RX callback function (RX only)
    %   
    %   Both callbacks take the server object as an argument. The TX
    %   callback is used to set the TX data pre-send, and the RX callback
    %   is used to process the RX data post-receive. A single message ID
    %   can have both a TX and RX protocol.
    %   
    %   Author: Dan Oates (WPI Class of 2020)
   
    properties (Access = private)
        serial_     % Serial port [serial]
        start_byte  % Start byte [uint8]
        tx_ids      % TX msg IDs [uint8]
        rx_ids      % RX msg IDs [uint8]
        tx_lens     % TX msg lengths [uint8]
        rx_lens     % RX msg lengths [uint8]
        tx_funcs    % TX msg callbacks [cell]
        rx_funcs    % RX msg callbacks [cell]
        tx_data     % TX data buffer [uint8]
        rx_data     % RX data buffer [uint8]
    end
    
    methods
        function obj = SerialServer(serial_, start_byte)
            %obj = SERIALSERVER(serial_, start_byte)
            %   Construct serial server
            %   
            %   Inputs:
            %   - serial_ = Serial port [serial]
            %   - start_byte = Message start byte [uint8]
            obj.serial_ = serial_;
            obj.start_byte = uint8(start_byte);
            obj.tx_ids = uint8([]);
            obj.rx_ids = uint8([]);
            obj.tx_lens = double([]);
            obj.rx_lens = double([]);
            obj.tx_funcs = {};
            obj.rx_funcs = {};
            obj.tx_data = uint8([]);
            obj.rx_data = uint8([]);
        end
        
        function serial_ = get_serial(obj)
            %serial_ = GET_SERIAL(obj) Get serial port object
            serial_ = obj.serial_;
        end
        
        function add_tx(obj, id, len, func)
            %ADD_TX(obj, id, len, func)
            %   Add TX message to server
            %   
            %   Inputs:
            %   - id = Message ID [uint8]
            %   - len = Message length [uint8]
            %   - func = Callback [function_handle]
            obj.tx_ids(end + 1) = id;
            obj.tx_lens(end + 1) = len;
            obj.tx_funcs{end + 1} = func;
        end
        
        function add_rx(obj, id, len, func)
            %ADD_RX(obj, id, len, func)
            %   Add RX message to server
            %   
            %   Inputs:
            %   - id = Message ID [uint8]
            %   - len = Message length [uint8]
            %   - func = Callback [function_handle]   
            obj.rx_ids(end + 1) = id;
            obj.rx_lens(end + 1) = len;
            obj.rx_funcs{end + 1} = func;
        end
        
        function set_tx_data(obj, tx_data)
            %SET_TX_DATA(obj, tx_data)
            %   Sets TX message data
            %   
            %   Inputs:
            %   - tx_data = TX mssage data [uint8]
            %   
            %   Call this at the end of a TX callback.
            obj.tx_data = uint8(tx_data);
        end
        
        function rx_data = get_rx_data(obj)
            %rx_data = GET_RX_DATA(obj)
            %   Gets RX message data
            %   
            %   Outputs:
            %   - rx_data = RX message data [uint8]
            %   
            %   Call this at the start of an RX callback.
            rx_data = obj.rx_data;
        end
        
        function tx(obj, id)
            %TX(obj, id) Transmits message with given ID
            id = uint8(id);
            tx_i = find(obj.tx_ids == id);
            if tx_i
                obj.tx_funcs{tx_i}(obj);
                fwrite(obj.serial_, obj.start_byte);
                fwrite(obj.serial_, id);
                fwrite(obj.serial_, obj.tx_data);
                checksum = uint8(mod(sum(uint64(obj.tx_data)), 256));
                fwrite(obj.serial_, checksum);
            else
                error('Invalid message ID: %u', id)
            end
        end
        
        function rx(obj)
            %RX(obj) Processes all incoming messages
            while obj.serial_.BytesAvailable

                % Check for start byte
                if uint8(fread(obj.serial_, 1)) == obj.start_byte
                    
                    % Find message by ID
                    id = uint8(fread(obj.serial_, 1));
                    rx_i = find(obj.rx_ids == id);
                    if rx_i
                        
                        % Read data
                        len = obj.rx_lens(rx_i);
                        obj.rx_data = fread(obj.serial_, len);
                        checksum = uint8(mod(sum(obj.rx_data), 256));
                        
                        % Validate checksum
                        if uint8(fread(obj.serial_, 1)) == checksum
                            obj.rx_funcs{rx_i}(obj);
                        end
                    else
                        flushinput(obj.serial_);
                    end
                else
                    flushinput(obj.serial_);
                end
            end
        end
    end
end