// Misc. additional useful definitions on FIFOs, Gets and Puts

import FIFOF::*;
import GetPut::*;
import ClientServer::*;

// A convenience function to 'pop' a value from a FIFO, FIFOF, ...
function ActionValue #(t) pop (ifc f)
   provisos (ToGet #(ifc, t));
   return toGet (f).get;
endfunction
