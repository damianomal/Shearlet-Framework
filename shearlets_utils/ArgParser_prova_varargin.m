function result = prova_parser_varargin( ban, varargin )
%PROVA_PARSER_VARARGIN Summary of this function goes here
%   Detailed explanation goes here

    A = ArgParser;
    
    A.addArg('int1', 'primo int', true, 11, 'double');
    A.addArg('int2', 'secondo int', false, 22, 'double');
    A.addArg('int3', 'terzo int', true, 'prova',  'char');
    
    result = A.parse(varargin);

    A.help;
    
    A.get('int3')
    
end

