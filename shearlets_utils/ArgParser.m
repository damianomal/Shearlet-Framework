classdef ArgParser < handle
    %ARGPARSER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        arg_names
        arg_helps
        arg_required
        arg_values
        arg_defaults
        arg_types
        processed
    end
    
    methods
        function obj = ArgParser
            obj.arg_names = {};
            obj.arg_helps = {};
            obj.arg_required = {};
            obj.arg_values = {};
            obj.arg_defaults = {};
            obj.arg_types = {};
            obj.processed = [];
        end
        
        function addArg(obj, name, help, req, def, vtype)
            
            % looks for the new parameter's name amongst
            % the already existing ones
            IndexC = strfind(obj.arg_names, name);
            Index = find(not(cellfun('isempty', IndexC)));
            
            % if it has not been found, adds it
            if(numel(Index) == 0)
                
                % if not specified, the parameter can be of any type
                if(nargin < 6)
                    vtype = 'any';
                end
                
                obj.arg_names{end+1} = name;
                obj.arg_helps{end+1} = help;
                obj.arg_required{end+1} = req;
                obj.arg_values{end+1} = def;
                obj.arg_defaults{end+1} = def;
                obj.arg_types{end+1} = vtype;
            else
                
                % throws an exception in case the specified parameter
                % already exists
                ME = MException('ArgParser:addArg', ...
                    'The inserted parameter already exists.');
                throw(ME);
            end
            
        end
        
        function reset(obj)
            
            % resets the arguments in the parser to
            % their default values
            for i = 1:numel(obj.arg_values)
                obj.arg_values{i} = obj.arg_defaults{i};
            end
            
        end
        
        function res = parse(obj, args)
            
            % extracts the names and the values for
            % the arguments passed
            new_names = args(1:2:end);
            new_vals = args(2:2:end);
            
            % checks that all the requires arguments
            % have been specified and passed to this function
            for index = find([obj.arg_required{:}] == true)
                if(~any(ismember(new_names, obj.arg_names{index})))
                    ME = MException('ArgParser:parse', ...
                        'The required parameters must be passed to the parse() call.');
                    throw(ME);
                end
            end
            
            %
            for i = 1:numel(new_names)
                
                %
                ind_temp = strfind(obj.arg_names, new_names{i});
                index = find(not(cellfun('isempty', ind_temp)));
                
                %
                if(numel(index) == 1)
                    
                    %
                    if(~strcmp(obj.arg_types{index},'any') && ~isa(new_vals{i}, obj.arg_types{index}))
                        ME = MException('ArgParser:parse', ...
                            'One of the argument is of the wrong type.');
                        throw(ME);
                    end
                    
                    %
                    obj.arg_values{index} = new_vals{i};
                else
                    % complete missing parameter code here
                    
                end
                
            end
            
            % returns the pairs parameter/value read as a struct
            res = cell2struct(obj.arg_values, obj.arg_names, 2);
            obj.processed = res;
            
        end
        
        function res = get(obj, name)
            
            % gets the index corresponding to the object
            % with the specified name
            ind_temp = strfind(obj.arg_names, name);
            index = find(not(cellfun('isempty', ind_temp)));
            
            % if found, returns the corresponding value
            if(numel(index) ~= 1)
                
                % print warning here
                warning('ArgParser:get', 'the requested parameter has not been found, [] has been returned.');
                res = [];
            else
                res = obj.arg_values{index};
            end
            
        end
        
        function res = set(obj, name, val)
            
            % gets the index corresponding to the object
            % with the specified name
            ind_temp = strfind(obj.arg_names, name);
            index = find(not(cellfun('isempty', ind_temp)));
            
            % if found, sets the corresponding value
            if(numel(index) ~= 1)
                
                % otherwise, displays a warning message
                warning('ArgParser:set', 'the requested parameter has not been found.');
                res = false;
            else
                
                % the specified value must have the correct type
                if(~strcmp(obj.arg_types{index},'any') && ~isa(val, obj.arg_types{index}))
                    warning('ArgParser:set', 'the requested parameter has a different type.');
                    res = false;
                else
                    
                    % sets the value, finally
                    obj.arg_values{index} = val;
                    res = true;
                    
                end
            end
            
        end
        
        function help(obj)
            
            fprintf('### Help for the ArgParser object ###\n');
            
            for i = 1:numel(obj.arg_names)
                fprintf('\nArgument: %s\n', obj.arg_names{i});
                fprintf('-- Help: %s\n', obj.arg_helps{i});
                
                if(obj.arg_required{i})
                    req = 'true';
                else
                    req = 'false';
                end
                
                fprintf('-- Required: %s\n', req);
                
                if(strcmp(obj.arg_types{i},'char'))
                    fprintf('-- Current Value (and default): %s (%s)\n\n', obj.arg_values{i}, obj.arg_defaults{i});
                else
                    if(strcmp(obj.arg_types{i},'double'))
                        fprintf('-- Current Value (and default): %d (%d)\n\n', obj.arg_values{i}, obj.arg_defaults{i});
                    end
                end
            end
            
            fprintf('#####################################\n');
        end
    end
    
end

