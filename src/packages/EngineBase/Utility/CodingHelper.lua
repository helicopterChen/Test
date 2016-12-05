local alien = require 'alien'   
WinProc_types = { ret = "long", abi = "stdcall"; "pointer", "uint", "uint", "long" }   
alien.kernel32.MultiByteToWideChar:types{ abi="stdcall"; ret="int";   
    "long" --[[CodePage]], "long" --[[dwFlags]], "pointer" --[[lpMultiByteStr]],   
    "long" --[[cbMultiByte]], "pointer" --[[lpWideCharStr]], "int" --[[cchWideChar]]}  
  
alien.kernel32.WideCharToMultiByte:types{ abi="stdcall"; ret="int";   
    "long" --[[CodePage]], "long" --[[dwFlags]], "pointer" --[[lpWideCharStr]],   
    "int" --[[cchWideChar]], "pointer" --[[lpMultiByteStr]], "int" --[[cbMultiByte]],  
    "string" --[[lpDefaultChar]], "pointer" --[[lpUsedDefaultChar]]}  
      
local CP_ACP  = 0;
local CP_UTF8 = 65001; 
  
function ASCII_TO_UTF8(str)   
    local codePage = CP_ACP;   
    local flags = 0;   
    local wide_len = alien.kernel32.MultiByteToWideChar(codePage, flags, str, #str+1, nil, 0);   
    local buffer = alien.buffer(2 * wide_len);   
    local res = alien.kernel32.MultiByteToWideChar(codePage, flags, str, #str+1, buffer, wide_len);   
    -- 上面已转为 UTF-16 编码，下面再转为 UTF-8  
    codePage = CP_UTF8   
    local multi_len = alien.kernel32.WideCharToMultiByte(codePage, flags, buffer ,  wide_len, nil, 0, nil, nil);  
    local res_buffer = alien.buffer(multi_len + 1);  
    res = alien.kernel32.WideCharToMultiByte(codePage, flags, buffer , wide_len, res_buffer, multi_len + 1, nil, nil);  
    return tostring(res_buffer);   
end  


function UTF8_TO_ASCII(str)   
    local codePage = CP_UTF8;   
    local flags = 0;   
    local wide_len = alien.kernel32.MultiByteToWideChar(codePage, flags, str, #str+1, nil, 0);   
    local buffer = alien.buffer(2 * wide_len);   
    local res = alien.kernel32.MultiByteToWideChar(codePage, flags, str, #str+1, buffer, wide_len);   
    -- 上面已转为 UTF-16 编码，下面再转为 UTF-8  
    codePage = CP_ACP   
    local multi_len = alien.kernel32.WideCharToMultiByte(codePage, flags, buffer ,  wide_len, nil, 0, nil, nil);  
    local res_buffer = alien.buffer(multi_len + 1);  
    res = alien.kernel32.WideCharToMultiByte(codePage, flags, buffer , wide_len, res_buffer, multi_len + 1, nil, nil);  
    return tostring(res_buffer);   
end  
